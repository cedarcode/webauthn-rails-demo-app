# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: session_params[:username])

    if user
      get_options = WebAuthn::Credential.options_for_get(allow: user.credentials.pluck(:external_id))

      user.update!(current_challenge: get_options.challenge)

      session[:username] = session_params[:username]

      respond_to do |format|
        format.json { render json: get_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: ["Username doesn't exist"] }, status: :unprocessable_entity }
      end
    end
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_get(params)

    user = User.find_by(username: session[:username])

    raise "user #{session[:username]} never initiated sign up" unless user

    credential = user.credentials.find_by(external_id: Base64.strict_encode64(webauthn_credential.raw_id))

    begin
      webauthn_credential.verify(
        user.current_challenge,
        public_key: credential.public_key,
        sign_count: credential.sign_count
      )

      if (entry = WebAuthn::Metadata::Store.new.fetch_entry(aaguid: credential.aaguid, attestation_certificate_key_id: credential.u2f_key_id))
        # As an example, prevent logging in with known compromised authenticators
        # Detailed information is available via `webauthn_credential.response.attestation_statement.metadata_statement`
        if (unsafe_status = Credential.unsafe_status?(entry.status_reports))
          Rails.logger.warn "User #{user.username} tried to login security key AAGUID #{entry.aaguid} with status #{unsafe_status.status}"

          render json: "Couldn't log in with your Security Key", status: :unprocessable_entity
          return
        end
      else
        # For demo purposes we do nothing if metadata is absent. For your application, you need to decide
        # whether not knowing metadata about an authenticator acceptable
      end

      credential.update!(sign_count: webauthn_credential.sign_count)
      sign_in(user)

      render json: { status: "ok" }, status: :ok
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    end
  end

  def destroy
    sign_out

    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:username)
  end
end
