# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def register_user
    visit root_path
    click_on "Register"
    fill_in "registration_username", with: "User1"
    fill_in "Credential Nickname", with: "USB key"
    click_on "Register using WebAuthn"
  end
end
