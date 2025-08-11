# frozen_string_literal: true

require "application_system_test_case"

class AddCredentialTest < ApplicationSystemTestCase
  def setup
    sign_up

    @authenticator = add_virtual_authenticator
  end

  def teardown
    @authenticator.remove!
  end

  test "add credentials" do
    visit root_path

    fill_in("credential_nickname", with: "Touch ID")

    click_on "Add Security Key"
    # wait for async response
    assert_text "Touch ID"

    assert_current_path "/"
    assert_text "USB key"
  end

  private

  def sign_up(username: "user", credential_nickname: "USB key")
    authenticator = add_virtual_authenticator

    visit new_registration_path

    fill_in "registration_username", with: username
    fill_in "Security Key nickname", with: credential_nickname

    click_on "Register using WebAuthn"
    # wait for async response
    assert_text "Your Security Keys"

    authenticator.remove!
  end
end
