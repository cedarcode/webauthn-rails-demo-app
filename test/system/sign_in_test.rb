# frozen_string_literal: true

require "application_system_test_case"

class SignInTest < ApplicationSystemTestCase
  def setup
    @authenticator = add_virtual_authenticator
  end

  def teardown
    @authenticator.remove!
  end

  test "register and then sign in" do
    visit new_registration_path

    fill_in "registration_username", with: "user"
    fill_in "Security Key nickname", with: "USB key"

    click_on "Register using WebAuthn"
    # wait for async response
    assert_button "account_circle"

    click_button "account_circle"
    click_on "Sign out"
    visit new_session_path

    fill_in "Username", with: "user"

    click_button "Sign in using WebAuthn"
    # wait for async response
    assert_button "account_circle"

    assert_current_path "/"
    assert_text 'USB key'
  end
end
