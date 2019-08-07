# frozen_string_literal: true

require "application_system_test_case"

class RegistrationFlowTest < ApplicationSystemTestCase
  test "register user with human interaction" do
    register_user
    # Human uses USB security key

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end
end
