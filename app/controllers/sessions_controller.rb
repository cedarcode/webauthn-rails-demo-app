# frozen_string_literal: true

require "webauthn/authentication"
require "webauthn/ceremony"

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: session_params[:username])

    if user
      authentication = WebAuthn::Authentication.new(user)
      authentication_options = authentication.options

      session[:current_challenge] = authentication_options.challenge
      session[:username] = session_params[:username]

      respond_to do |format|
        format.json { render json: authentication_options }
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

    authentication = WebAuthn::Authentication.new(user)

    if authentication.perform(session[:current_challenge], params)
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
