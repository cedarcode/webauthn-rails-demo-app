# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: session_params[:username])

    if user
      # XXX: Shouldn't need to pass {}
      get_options = relying_party.options_for_authentication({}, allow: user.credentials.pluck(:external_id))

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
      webauthn_credential = relying_party.verify_authentication(
        params,
        user.current_challenge,
        public_key: credential.public_key,
        sign_count: credential.sign_count
      )

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
