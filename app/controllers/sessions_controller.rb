# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: session_params[:username])

    if user
      webauthn_credential = WebauthnCredential.new(user)
      authenticate_options = webauthn_credential.authenticate_options

      session[:current_challenge] = authenticate_options.challenge
      session[:username] = session_params[:username]

      respond_to do |format|
        format.json { render json: authenticate_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: ["Username doesn't exist"] }, status: :unprocessable_entity }
      end
    end
  end

  def callback
    user = User.find_by(username: session[:username])

    raise "user #{session[:username]} never initiated sign up" unless user

    webauthn_credential = WebauthnCredential.new(user)

    if webauthn_credential.authenticate(session[:current_challenge], params)
      sign_in(user)

      render json: { status: "ok" }, status: :ok
    else
      render json: "Verification failed", status: :unprocessable_entity
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
