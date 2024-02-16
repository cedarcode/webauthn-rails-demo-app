# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
  end

  def create
    user = User.new(username: params[:registration][:username])

    create_options = relying_party.options_for_registration(
      user: {
        name: params[:registration][:username],
        id: user.webauthn_id
      },
      authenticator_selection: {
        user_verification: "required",
        resident_key: 'discouraged',
      }
    )

    if user.valid?
      session[:current_registration] = { challenge: create_options.challenge, user_attributes: user.attributes }

      respond_to do |format|
        format.json { render json: create_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def callback
    user = User.create!(session[:current_registration][:user_attributes])

    begin
      webauthn_credential = relying_party.verify_registration(
        params,
        session[:current_registration][:challenge],
        user_verification: true,
      )

      credential = user.credentials.build(
        external_id: Base64.strict_encode64(webauthn_credential.raw_id),
        nickname: params[:credential_nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count,
        uv_initialized: webauthn_credential.send(:authenticator_data).user_verified?,
        transports: params['response']['transports'],
        backup_eligible: webauthn_credential.backup_eligible?,
        backup_state: webauthn_credential.backed_up?,
      )

      if credential.save
        sign_in(user)

        render json: { status: "ok" }, status: :ok
      else
        render json: "Couldn't register your Security Key", status: :unprocessable_entity
      end
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    ensure
      session.delete(:current_registration)
    end
  end
end
