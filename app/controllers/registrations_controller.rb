# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
  end

  def create
    user = User.new(username: registration_params[:username])

    create_options = WebAuthn::Credential.options_for_create(
      user: {
        name: registration_params[:username],
        id: bin_to_str(registration_params[:username])
      }
    )

    if user.update(current_challenge: create_options.challenge)
      session[:username] = registration_params[:username]

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

    user = User.find_by(username: session[:username])

    raise "user #{session[:username]} never initiated sign up" unless user

    if webauthn_credential.verify(user.current_challenge)
      credential = user.credentials.find_or_initialize_by(
        external_id: Base64.strict_encode64(webauthn_credential.raw_id)
      )

      if credential.update(
        nickname: params[:credential_nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )
        sign_in(user)

        render json: { status: "ok" }, status: :ok
      else
        render json: { errors: ["Couldn't register your Security Key"] }, status: :unprocessable_entity
      end
    else
      render json: { status: "forbidden" }, status: :forbidden
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:username)
  end
end
