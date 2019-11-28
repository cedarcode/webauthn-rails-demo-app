# frozen_string_literal: true

require "webauthn"
require "webauthn/ceremony"

module WebAuthn
  class Registration < Ceremony
    def options
      # webauthn
      WebAuthn::Credential.options_for_create(
        user: {
          id: user.webauthn_id,
          name: user.username, # username db column
        },
        exclude: user.credentials.pluck(:external_id) # credentials collection + pluck(AR)
      )
    end

    def perform(challenge, params)
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
  end
end
