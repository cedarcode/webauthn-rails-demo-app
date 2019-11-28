# frozen_string_literal: true

require "webauthn"
require "webauthn/ceremony"

module WebAuthn
  class Authentication < Ceremony
    def options
      WebAuthn::Credential.options_for_get(allow: user.credentials.pluck(:external_id))
    end

    def perform(challenge, params)
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
end
