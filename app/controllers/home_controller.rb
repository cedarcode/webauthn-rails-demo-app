class HomeController < ApplicationController
  before_action :enforce_current_user

  helper_method :current_user

  def index
  end

  private

  def current_user
    @current_user
  end

  def enforce_current_user
    if !current_user.present?
      redirect_to new_session_path
    end
  end
end
