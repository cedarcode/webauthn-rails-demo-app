# frozen_string_literal: true

require "webauthn"

class WebauthnCredential
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def register_options
    # webauthn
    WebAuthn::Credential.options_for_create(
      user: {
        id: user.webauthn_id,
        name: user.username, # username db column
      },
      exclude: user.credentials.pluck(:external_id) # credentials collection + pluck(AR)
    )
  end

  def register(challenge, params)
    webauthn_credential = WebAuthn::Credential.from_create(params)

    begin
      webauthn_credential.verify(challenge)

      credential = user.credentials.find_or_initialize_by(
        external_id: Base64.strict_encode64(webauthn_credential.raw_id)
      ) # AR

      credential.update(
        nickname: params[:credential_nickname],
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      ) # AR
    rescue WebAuthn::Error
      false
    end
  end

  def authenticate_options
    WebAuthn::Credential.options_for_get(allow: user.credentials.pluck(:external_id))
  end

  def authenticate(challenge, params)
    webauthn_credential = WebAuthn::Credential.from_get(params)

    credential = user.credentials.find_by(external_id: Base64.strict_encode64(webauthn_credential.raw_id))

    begin
      webauthn_credential.verify(
        challenge,
        public_key: credential.public_key,
        sign_count: credential.sign_count
      )

      credential.update!(sign_count: webauthn_credential.sign_count)

      true
    rescue WebAuthn::Error
      false
    end
  end
end
