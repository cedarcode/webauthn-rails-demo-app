# frozen_string_literal: true

require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
  test "register user with human interaction" do
    visit new_registration_path
    fill_in "registration_username", with: "User1"
    fill_in "Credential Nickname", with: "USB key"
    click_on "Register using WebAuthn"
    # Human uses USB security key

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end
end
