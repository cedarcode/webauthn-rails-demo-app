# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def sign_in(user)
    session[:user_id] = user.id
    user.update!(current_challenge: nil)
  end

  def sign_out
    session[:user_id] = nil
  end

  def current_user
    @current_user ||=
      if session[:user_id]
        User.find_by(id: session[:user_id])
      end
  end

  def relying_party
    @relying_party ||=
      WebAuthn::RelyingParty.new(
        origin: ENV["WEBAUTHN_ORIGIN"],
        name: "WebAuthn Rails Demo App"
      )
  end
end
