# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||=
      if session[:user_id]
        User.find_by(id: session[:user_id])
      end
  end

  def relying_party
    @relying_party ||=
      WebAuthn::RelyingParty.new(
        origin: Rails.configuration.webauthn_origin,
        name: "WebAuthn Rails Demo App"
      )
  end
end
