# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should initiate registration successfully" do
    post registration_url, params: { registration: { username: "alice" }, format: :json }

    assert_response :success
  end
end
