# frozen_string_literal: true

require "application_system_test_case"

class AddCredentialFlowTest < ApplicationSystemTestCase
  test "add credential with human interaction" do
    register_user
    # Human uses USB security key

    fill_in("credential_nickname", with: "Touch ID")
    click_on "Add Credential"
    # Human uses Touch ID sensor

    assert_text 'Touch ID'
    assert_text 'USB key'
  end
end
