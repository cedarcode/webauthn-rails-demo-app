# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
  end

  def create_options
    user = User.new(username: registration_params[:username])

    create_options = WebAuthn::Credential.options_for_create(
      user: {
        name: registration_params[:username],
        id: user.webauthn_id
      },
      authenticator_selection: { user_verification: "required" }
    )

    if user.valid?
      session[:current_registration] = { challenge: create_options.challenge, user_attributes: user.attributes }

      respond_to do |format|
        format.json { render json: create_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: user.errors.full_messages }, status: :unprocessable_content }
      end
    end
  end

  def create
    webauthn_credential = WebAuthn::Credential.from_create(JSON.parse(registration_params[:public_key_credential]))

    user = User.new(session[:current_registration]["user_attributes"])

    begin
      webauthn_credential.verify(session[:current_registration]["challenge"], user_verification: true)

      user.credentials.build(
        external_id: webauthn_credential.id,
        nickname: registration_params[:nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )

      if user.save
        sign_in(user)

        redirect_to root_path, notice: "Security Key registered successfully"
      else
        redirect_to new_registration_path, alert: "Couldn't register your Security Key"
      end
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_content
    ensure
      session.delete(:current_registration)
    end
  end

  def registration_params
    params.require(:registration).permit(:username, :nickname, :public_key_credential)
  end
end
