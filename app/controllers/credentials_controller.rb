# frozen_string_literal: true

class CredentialsController < ApplicationController
  def create
    create_options = WebAuthn::PublicKeyCredential.create_options(
      user: {
        id: bin_to_str(current_user.username),
        name: current_user.username,
      },
      exclude: current_user.credentials.pluck(:external_id)
    )

    current_user.update!(current_challenge: create_options.challenge)

    respond_to do |format|
      format.json { render json: create_options }
    end
  end

  def callback
    auth_response = WebAuthn::AuthenticatorAttestationResponse.new(
      attestation_object: str_to_bin(params[:response][:attestationObject]),
      client_data_json: str_to_bin(params[:response][:clientDataJSON])
    )

    if auth_response.verify(str_to_bin(current_user.current_challenge))
      if params[:response][:attestationObject].present?
        credential = current_user.credentials.find_or_initialize_by(
          external_id: Base64.strict_encode64(auth_response.credential.id)
        )

        credential.update!(
          nickname: params[:credential_nickname],
          public_key: Base64.strict_encode64(auth_response.credential.public_key),
          sign_count: auth_response.authenticator_data.sign_count,
        )
      end

      render json: { status: "ok" }, status: :ok
    else
      render json: { status: "forbidden" }, status: :forbidden
    end
  end

  def destroy
    if current_user&.can_delete_credentials?
      current_user.credentials.destroy(params[:id])
    end

    redirect_to root_path
  end
end
