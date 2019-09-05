# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: session_params[:username])

    if user
      get_options = WebAuthn::PublicKeyCredential.get_options(allow: user.credentials.pluck(:external_id))

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
    public_key_credential = WebAuthn::PublicKeyCredential.from_get(params)

    user = User.find_by(username: session[:username])

    raise "user #{session[:username]} never initiated sign up" unless user

    credential = user.credentials.find_by(external_id: Base64.strict_encode64(public_key_credential.raw_id))
    public_key = Base64.strict_decode64(credential.public_key)

    if public_key_credential.verify(
      user.current_challenge,
      public_key: public_key,
      sign_count: credential.sign_count
    )
      credential.update!(sign_count: public_key_credential.sign_count)
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
