# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
  end

  def create
    user = User.new(username: registration_params[:username])

    create_options = WebAuthn::PublicKeyCredential.create_options(
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
    public_key_credential = WebAuthn::PublicKeyCredential.from_create(params)

    user = User.find_by(username: session[:username])

    raise "user #{session[:username]} never initiated sign up" unless user

    if public_key_credential.verify(str_to_bin(user.current_challenge))
      credential = user.credentials.find_or_initialize_by(
        external_id: Base64.strict_encode64(public_key_credential.raw_id)
      )

      credential.update!(
        nickname: params[:credential_nickname],
        public_key: Base64.strict_encode64(public_key_credential.public_key),
        sign_count: public_key_credential.sign_count
      )

      sign_in(user)

      render json: { status: "ok" }, status: :ok
    else
      render json: { status: "forbidden" }, status: :forbidden
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:username)
  end
end
