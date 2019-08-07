# frozen_string_literal: true

require "application_system_test_case"

class SignInFlowTest < ApplicationSystemTestCase
  test "register with human interaction and then sign in" do
    register_user
    # Human uses USB security key

    click_button "account_circle"
    click_on "Sign out"

    sign_in
    # Human uses USB security key

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end
end
