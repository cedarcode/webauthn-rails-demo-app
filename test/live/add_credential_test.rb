# frozen_string_literal: true

require "application_system_test_case"

class AddCredentialTest < ApplicationSystemTestCase
  test "add credential with human interaction" do
    visit new_registration_path
    fill_in "registration_username", with: "User1"
    fill_in "Credential Nickname", with: "USB key"
    click_on "Register using WebAuthn"
    # Human uses USB security key

    fill_in("credential_nickname", with: "Touch ID")
    click_on "Add Credential"
    # Human uses Touch ID sensor

    assert_text 'Touch ID'
    assert_text 'USB key'
  end
end
