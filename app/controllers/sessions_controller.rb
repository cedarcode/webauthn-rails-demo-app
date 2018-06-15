class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(email: session_params[:email]).first_or_create!

    if user.credentials.any? && session_params[:add_credential] != "1"
      credential_options = WebAuthn.credential_request_options
      credential_options[:allowCredentials] = user.credentials.map do |cred|
        { id: cred.raw_id, type: "public-key" }
      end
    else
      credential_options = WebAuthn.credential_creation_options
      credential_options[:user][:id] = Base64.strict_encode64(session_params[:email])
      credential_options[:user][:name] = session_params[:email]
      credential_options[:user][:displayName] = session_params[:email]
    end

    credential_options[:challenge] = bin_to_str(credential_options[:challenge])
    user.update!(current_challenge: credential_options[:challenge])

    session[:email] = session_params[:email]
    session[:add_credential] = session_params[:add_credential]

    respond_to do |format|
      format.json { render json: credential_options }
    end
  end

  def callback
    if params[:response][:attestationObject].present?
      auth_response = WebAuthn::AuthenticatorAttestationResponse.new(
        attestation_object: str_to_bin(params[:response][:attestationObject]),
        client_data_json: str_to_bin(params[:response][:clientDataJSON])
      )

      user = User.where(email: session[:email]).take

      if user
        if auth_response.valid?(str_to_bin(user.current_challenge), request.base_url)
          if params[:response][:attestationObject].present?
            credential = user.credentials.find_or_initialize_by(
              raw_id: Base64.strict_encode64(auth_response.credential.id)
            )

            credential.update!(public_key: Base64.strict_encode64(auth_response.credential.public_key))
          end

          sign_in(user)

          render json: { status: "ok" }, status: :ok
        else
          render json: { status: "forbidden"}, status: :forbidden
        end
      else
        raise "user #{session[:email]} never initiated sign up"
      end
    else
      auth_response = WebAuthn::AuthenticatorAssertionResponse.new(
        credential_id: str_to_bin(params[:id]),
        client_data_json: str_to_bin(params[:response][:clientDataJSON]),
        authenticator_data: str_to_bin(params[:response][:authenticatorData]),
        #user_handle: params[:response][:userHandle],
        signature: str_to_bin(params[:response][:signature])
      )

      user = User.where(email: session[:email]).take

      if user
        allowed_credentials = user.credentials.map do |cred|
          {
            id: Base64.strict_decode64(cred.raw_id),
            public_key: Base64.strict_decode64(cred.public_key)
          }
        end

        if auth_response.valid?(
            str_to_bin(user.current_challenge),
            request.base_url,
            allowed_credentials: allowed_credentials
        )
          sign_in(user)

          render json: { status: "ok" }, status: :ok
        else
          render json: { status: "forbidden"}, status: :forbidden
        end
      else
        raise "user #{session[:email]} never initiated sign up"
      end
    end
  end

  private

  def str_to_bin(str)
    Base64.strict_decode64(str)
  end

  def bin_to_str(bin)
    Base64.strict_encode64(bin)
  end

  def session_params
    params.require(:session).permit(:email, :add_credential)
  end
end
