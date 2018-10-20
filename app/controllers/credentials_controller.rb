# frozen_string_literal: true

class CredentialsController < ApplicationController
  def create
    credential_options = WebAuthn.credential_creation_options
    credential_options[:user][:id] = Base64.strict_encode64(current_user.username)
    credential_options[:user][:name] = current_user.username
    credential_options[:user][:displayName] = current_user.username

    credential_options[:challenge] = bin_to_str(credential_options[:challenge])
    current_user.update!(current_challenge: credential_options[:challenge])

    respond_to do |format|
      format.json { render json: credential_options.merge(user_id: current_user.id) }
    end
  end

  def callback
    auth_response = WebAuthn::AuthenticatorAttestationResponse.new(
      attestation_object: str_to_bin(params[:response][:attestationObject]),
      client_data_json: str_to_bin(params[:response][:clientDataJSON])
    )

    if auth_response.valid?(str_to_bin(current_user.current_challenge), request.base_url)
      if params[:response][:attestationObject].present?
        credential = current_user.credentials.find_or_initialize_by(
          external_id: Base64.strict_encode64(auth_response.credential.id)
        )

        credential.update!(
          nickname: params[:credential_nickname],
          public_key: Base64.strict_encode64(auth_response.credential.public_key)
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
