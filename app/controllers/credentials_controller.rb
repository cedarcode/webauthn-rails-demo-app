# frozen_string_literal: true

class CredentialsController < ApplicationController
  def options
    create_options = WebAuthn::Credential.options_for_create(
      user: {
        id: current_user.webauthn_id,
        name: current_user.username,
      },
      exclude: current_user.credentials.pluck(:external_id),
      authenticator_selection: { user_verification: "required" }
    )

    session[:current_registration] = { challenge: create_options.challenge }

    respond_to do |format|
      format.json { render json: create_options }
    end
  end

  def create
    webauthn_credential = WebAuthn::Credential.from_create(JSON.parse(credential_params[:public_key_credential]))

    begin
      webauthn_credential.verify(session[:current_registration]["challenge"], user_verification: true)

      credential = current_user.credentials.find_or_initialize_by(
        external_id: webauthn_credential.id
      )

      if credential.update(
        nickname: credential_params[:nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )
        redirect_to root_path, notice: "Security Key registered successfully"
      else
        current_user.credentials.destroy(credential.id) if credential.persisted?
        redirect_to root_path, alert: "Couldn't register your Security Key"
      end
    rescue WebAuthn::Error => e
      redirect_to root_path, alert: "Verification failed: #{e.message}"
    ensure
      session.delete(:current_registration)
    end
  end

  def destroy
    if current_user&.can_delete_credentials?
      current_user.credentials.destroy(params[:id])
    end

    redirect_to root_path
  end

  def credential_params
    params.expect(credential: [:public_key_credential, :nickname])
  end
end
