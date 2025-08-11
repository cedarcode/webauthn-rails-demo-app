# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
  end

  def create
    user = User.new(username: params[:registration][:username])

    create_options = WebAuthn::Credential.options_for_create(
      user: {
        name: params[:registration][:username],
        id: user.webauthn_id
      },
      authenticator_selection: { user_verification: "required" }
    )

    if user.valid?
      session[:current_registration] = { challenge: create_options.challenge, user_attributes: user.attributes }

      respond_to do |format|
        format.json { render json: create_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: user.errors.full_messages }, status: :unprocessable_content }
      end
    end
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_create(params)

    user = User.new(session[:current_registration]["user_attributes"])

    begin
      webauthn_credential.verify(session[:current_registration]["challenge"], user_verification: true)

      user.credentials.build(
        external_id: webauthn_credential.id,
        nickname: params[:credential_nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )

      if user.save
        sign_in(user)

        render json: { status: "ok" }, status: :ok
      else
        render json: "Couldn't register your Security Key", status: :unprocessable_content
      end
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_content
    ensure
      session.delete(:current_registration)
    end
  end
end
