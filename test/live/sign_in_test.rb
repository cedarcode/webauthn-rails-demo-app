# frozen_string_literal: true

require "application_system_test_case"

class SignInTest < ApplicationSystemTestCase
  test "register with human interaction and then sign in" do
    visit new_registration_path
    fill_in "registration_username", with: "User1"
    fill_in "Security Key nickname", with: "USB key"
    click_on "Register using WebAuthn"
    # Human uses USB security key

    click_button "account_circle"
    click_on "Sign out"

    visit new_session_path
    fill_in "Username", with: "User1"
    click_button "Sign in using WebAuthn"
    # Human uses USB security key

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end
end
