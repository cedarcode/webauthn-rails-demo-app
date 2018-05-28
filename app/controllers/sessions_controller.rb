class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(email: session_params[:email]).first_or_create!

    if user.credential.present?
      warn "email already registerd"
    end

    credential_creation_options = WebAuthn.credential_creation_options
    credential_creation_options[:user][:id] = Base64.urlsafe_encode64(session_params[:email])
    credential_creation_options[:user][:name] = session_params[:email]
    credential_creation_options[:user][:displayName] = session_params[:email]

    user.update!(current_challenge: credential_creation_options[:challenge])

    session[:email] = session_params[:email]

    respond_to do |format|
      format.json { render json: credential_creation_options }
    end
  end

  def callback
    attestation_response = WebAuthn::AuthenticatorAttestationResponse.new(
      attestation_object: params[:response][:attestationObject],
      client_data_json: params[:response][:clientDataJSON]
    )

    user = User.where(email: session[:email]).take

    if user
      if attestation_response.valid?(user.current_challenge, request.base_url)
        user.update!(credential: Base64.encode64(attestation_response.credential_id))
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
