# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
  end

  def create
    user = User.new(username: registration_params[:username])

    credential_options = WebAuthn.credential_creation_options
    credential_options[:user][:id] = Base64.strict_encode64(registration_params[:username])
    credential_options[:user][:name] = registration_params[:username]
    credential_options[:user][:displayName] = registration_params[:username]

    credential_options[:challenge] = bin_to_str(credential_options[:challenge])

    if user.update(current_challenge: credential_options[:challenge])
      session[:username] = registration_params[:username]

      respond_to do |format|
        format.json { render json: credential_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def callback
    auth_response = WebAuthn::AuthenticatorAttestationResponse.new(
      attestation_object: str_to_bin(params[:response][:attestationObject]),
      client_data_json: str_to_bin(params[:response][:clientDataJSON])
    )

    user = User.find_by(username: session[:username])

    raise "user #{session[:username]} never initiated sign up" unless user

    render json: { status: "forbidden" },
           status: :forbidden unless auth_response.valid?(str_to_bin(user.current_challenge), request.base_url)

    credential = user.credentials.find_or_initialize_by(
      external_id: Base64.strict_encode64(auth_response.credential.id)
    )
    credential.update!(
      nickname: params[:credential_nickname],
      public_key: Base64.strict_encode64(auth_response.credential.public_key)
    )

    sign_in(user)
    render json: { status: "ok" }, status: :ok
  end

  private

  def registration_params
    params.require(:registration).permit(:username)
  end
end
