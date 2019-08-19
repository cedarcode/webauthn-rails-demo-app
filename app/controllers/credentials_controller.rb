# frozen_string_literal: true

class CredentialsController < ApplicationController
  def create
    credential_options = WebAuthn.credential_creation_options(
      user_id: bin_to_str(current_user.username),
      user_name: current_user.username,
      display_name: current_user.username
    )

    credential_options[:excludeCredentials] = current_user.credentials.map do |credential|
      { id: credential.external_id, type: "public-key" }
    end

    credential_options[:challenge] = bin_to_str(credential_options[:challenge])
    current_user.update!(current_challenge: credential_options[:challenge])

    respond_to do |format|
      format.json { render json: credential_options.merge(user_id: current_user.id) }
    end
  end

  def callback
    public_key_credential = WebAuthn::PublicKeyCredential.from_create(params)

    if public_key_credential.verify(str_to_bin(current_user.current_challenge))
      if params[:response][:attestationObject].present?
        credential = current_user.credentials.find_or_initialize_by(
          external_id: Base64.strict_encode64(public_key_credential.raw_id)
        )

        credential.update!(
          nickname: params[:credential_nickname],
          public_key: Base64.strict_encode64(public_key_credential.public_key)
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
