# frozen_string_literal: true

class CredentialsController < ApplicationController
  def create
    webauthn_credential = WebauthnCredential.new(current_user)

    register_options = webauthn_credential.register_options

    session[:current_challenge] = register_options.challenge

    respond_to do |format|
      format.json { render json: register_options }
    end
  end

  def callback
    webauthn_user = WebauthnCredential.new(current_user)

    if webauthn_user.register(session[:current_challenge], params)
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
