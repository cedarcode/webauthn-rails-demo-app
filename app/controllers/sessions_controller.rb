# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: session_params[:username])

    if user
      credential_options = WebAuthn.credential_request_options
      credential_options[:allowCredentials] = user.credentials.map do |cred|
        { id: cred.external_id, type: "public-key" }
      end

      credential_options[:challenge] = bin_to_str(credential_options[:challenge])
      user.update!(current_challenge: credential_options[:challenge])

      session[:username] = session_params[:username]

      respond_to do |format|
        format.json { render json: credential_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: ["Username doesn't exist"] }, status: :unprocessable_entity }
      end
    end
  end

  def callback
    auth_response = WebAuthn::AuthenticatorAssertionResponse.new(
      client_data_json: str_to_bin(params[:response][:clientDataJSON]),
      authenticator_data: str_to_bin(params[:response][:authenticatorData]),
      signature: str_to_bin(params[:response][:signature])
    )

    user = User.find_by(username: session[:username])

    raise "user #{session[:username]} never initiated sign up" unless user

    public_key =
      Base64.strict_decode64(
        user.credentials.find_by(external_id: Base64.strict_encode64(str_to_bin(params[:id]))).public_key
      )

    if auth_response.verify(str_to_bin(user.current_challenge), public_key: public_key)
      sign_in(user)
      render json: { status: "ok" }, status: :ok
    else
      render json: { status: "forbidden" }, status: :forbidden
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
