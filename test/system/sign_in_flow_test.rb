# frozen_string_literal: true

require "application_system_test_case"

class SignInFlowTest < ApplicationSystemTestCase
  test "login after registering with human interaction" do
    register_user

    # Human uses USB security key

    click_button "account_circle"
    click_on "Sign out"

    fill_in "Username", with: "User1"
    click_button "Sign in using WebAuthn"

    # Human uses USB security key

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end
end
