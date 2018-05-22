class SessionsController < ApplicationController


  def new
  end

  def create
    credential_creation_options = WebAuthn.credential_creation_options

    session[:challenge] = credential_creation_options[:challenge]

    @credential_creation_options = credential_creation_options
    respond_to :js
  end

  def callback
    valid = WebAuthn.valid?(
      original_challenge: session[:challenge],
      attestation_object: params[:response][:attestationObject],
      client_data_bin: params[:response][:clientDataJSON]
    )

    if valid
      render json: { status: "ok" }, status: :ok
    else
      render json: { status: "forbidden"}, status: :forbidden
    end
  end
end
