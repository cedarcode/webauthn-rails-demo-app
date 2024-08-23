# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should initiate registration successfully" do
    User.create!(username: "alice")

    post session_url, params: { session: { username: "alice" }, format: :json }

    assert_response :success
  end

  test "should return error if creating session with inexisting username" do
    post session_url, params: { session: { username: "alice" }, format: :json }

    assert_response :unprocessable_entity
    assert_equal ["Username doesn't exist"], response.parsed_body["errors"]
  end

  test "should return error if creating session with blank username" do
    post session_url, params: { session: { username: "" }, format: :json }

    assert_response :unprocessable_entity
    assert_equal ["Username doesn't exist"], response.parsed_body["errors"]
  end
end
