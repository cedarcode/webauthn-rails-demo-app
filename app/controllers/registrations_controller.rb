# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
  end

  def create
    user = User.new(username: params[:registration][:username])

    create_options = WebAuthn::Credential.options_for_create(
      user: {
        name: params[:registration][:username],
        id: user.webauthn_id
      },
      attestation: 'direct'
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
    webauthn_credential = WebAuthn::Credential.from_create(params)

    user = User.create!(session["current_registration"]["user_attributes"])

    begin
      webauthn_credential.verify(session["current_registration"]["challenge"])

      if (entry = webauthn_credential.response.attestation_statement.metadata_entry)
        # As an example, prevent registration of known compromised authenticators
        # Detailed information is available via `webauthn_credential.response.attestation_statement.metadata_statement`
        if (unsafe_status = Credential.unsafe_status?(entry.status_reports))
          Rails.logger.warn "User #{user.username} tried to register security key #{entry.aaguid} with status #{unsafe_status.status}"

          render json: "Couldn't register your Security Key", status: :unprocessable_entity
          return
        end
      else
        # For demo purposes we do nothing if metadata is absent. For your application, you need to decide
        # whether not knowing metadata about an authenticator acceptable
      end

      byebug
      credential = user.credentials.build(
        external_id: Base64.strict_encode64(webauthn_credential.raw_id),
        nickname: params[:credential_nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count,
        aaguid: webauthn_credential.response.aaguid,
        u2f_key_id: webauthn_credential.response.attestation_certificate_key_id,
      )

      if credential.save
        sign_in(user)

        render json: { status: "ok" }, status: :ok
      else
        render json: "Couldn't register your Security Key", status: :unprocessable_entity
      end
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    end
  end
end
