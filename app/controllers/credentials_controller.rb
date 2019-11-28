# frozen_string_literal: true

require "webauthn/registration"

class CredentialsController < ApplicationController
  def create
    registration = WebAuthn::Registration.new(current_user)

    registration_options = registration.options

    session[:current_challenge] = registration_options.challenge

    respond_to do |format|
      format.json { render json: registration_options }
    end
  end

  def callback
    registration = WebAuthn::Registration.new(current_user)

    if registration.perform(session[:current_challenge], params)
      render json: { status: "ok" }, status: :ok
    else
      render json: "Couldn't add your Security Key", status: :unprocessable_entity
    end
  end

  def destroy
    if current_user&.can_delete_credentials?
      current_user.credentials.destroy(params[:id])
    end

    redirect_to root_path
  end
end
