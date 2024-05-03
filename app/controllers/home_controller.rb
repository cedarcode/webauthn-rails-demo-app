# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :enforce_current_user

  def index
  end

  private

  def enforce_current_user
    if current_user.blank?
      redirect_to webauthn_rails.new_session_path
    end
  end
end
