# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def relying_party
    @relying_party ||=
      WebAuthn::RelyingParty.new(
        origin: Rails.configuration.webauthn_origin,
        name: "WebAuthn Rails Demo App"
      )
  end
end
