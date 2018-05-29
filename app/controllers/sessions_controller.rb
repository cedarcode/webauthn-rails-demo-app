class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(email: session_params[:email]).first_or_create!

    if user.credential.present?
      credential_options = WebAuthn.credential_request_options

    else
      credential_options = WebAuthn.credential_creation_options
      credential_options[:user][:id] = Base64.urlsafe_encode64(session_params[:email])
      credential_options[:user][:name] = session_params[:email]
      credential_options[:user][:displayName] = session_params[:email]
    end

    user.update!(current_challenge: credential_options[:challenge])

    session[:email] = session_params[:email]

    respond_to do |format|
      format.json { render json: credential_options }
    end
  end

  def callback
    if params[:response][:attestationObject].present?
      auth_response = WebAuthn::AuthenticatorAttestationResponse.new(
        attestation_object: params[:response][:attestationObject],
        client_data_json: params[:response][:clientDataJSON]
      )
    else
      auth_response = WebAuthn::AuthenticatorAssertionResponse.new(
        client_data_json: params[:response][:clientDataJSON],
        authenticator_data: params[:response][:authenticatorData],
        user_handle: params[:response][:userHandle],
        signature: params[:response][:signature]
      )
    end

    user = User.where(email: session[:email]).take

    if user
      if auth_response.valid?(user.current_challenge, request.base_url)
        if params[:response][:attestationObject].present?
          user.update!(credential: Base64.encode64(auth_response.credential_id))
        end

        sign_in(user)

        render json: { status: "ok" }, status: :ok
      else
        render json: { status: "forbidden"}, status: :forbidden
      end
    else
      raise "user #{session[:email]} never initiated sign up"
    end
  end

  private

  def session_params
    params.require(:session).permit(:email)
  end
end
