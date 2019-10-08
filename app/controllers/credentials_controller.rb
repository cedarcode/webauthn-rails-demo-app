# frozen_string_literal: true

class CredentialsController < ApplicationController
  def create
    create_options = WebAuthn::Credential.options_for_create(
      user: {
        id: current_user.webauthn_id,
        name: current_user.username,
      },
      exclude: current_user.credentials.pluck(:external_id)
    )

    session[:current_registration] = { challenge: create_options.challenge }

    respond_to do |format|
      format.json { render json: create_options }
    end
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_create(params)

    begin
      webauthn_credential.verify(session["current_registration"]["challenge"])

      credential = current_user.credentials.find_or_initialize_by(
        external_id: Base64.strict_encode64(webauthn_credential.raw_id)
      )

      if credential.update(
        nickname: params[:credential_nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )
        render json: { status: "ok" }, status: :ok
      else
        render json: "Couldn't add your Security Key", status: :unprocessable_entity
      end
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    ensure
      session.delete("current_registration")
    end
  end

  def destroy
    if current_user&.can_delete_credentials?
      current_user.credentials.destroy(params[:id])
    end

    redirect_to root_path
  end
end
