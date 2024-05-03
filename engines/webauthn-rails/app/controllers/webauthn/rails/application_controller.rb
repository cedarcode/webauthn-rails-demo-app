module Webauthn
  module Rails
    class ApplicationController < ::ApplicationController
      private

      def sign_in(user)
        session[:user_id] = user.id
      end

      def sign_out
        session[:user_id] = nil
      end

      def relying_party
        @relying_party ||=
          WebAuthn::RelyingParty.new(
            origin: Webauthn::Rails.webauthn_origin,
            name: "WebAuthn Rails Demo App"
          )
      end
    end
  end
end
