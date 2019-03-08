# frozen_string_literal: true

require 'test_helper'
require "webauthn/fake_authenticator"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should initiate registration successfully" do
    User.create!(username: "alice")

    post session_url, params: { session: { username: "alice" }, format: :json }

    assert_response :success
  end

  test "should return error if creating session with inexisting username" do
    post session_url, params: { session: { username: "alice" }, format: :json }

    assert_response :unprocessable_entity
    assert_equal ["Username doesn't exist"], JSON.parse(response.body)["errors"]
  end

  test "should return error if creating session with blank username" do
    post session_url, params: { session: { username: "" }, format: :json }

    assert_response :unprocessable_entity
    assert_equal ["Username doesn't exist"], JSON.parse(response.body)["errors"]
  end

  test "callback works" do
    user = User.create!(username: "alice")

    create_authenticator = WebAuthn::FakeAuthenticator::Create.new

    user.credentials.create!(
      nickname: "credential",
      external_id: Base64.strict_encode64(create_authenticator.credential_id),
      public_key: Base64.strict_encode64(create_authenticator.credential_key.public_key.to_bn.to_s(2))
    )

    post session_url, params: { session: { username: "alice" }, format: :json }

    user.reload

    authenticator = WebAuthn::FakeAuthenticator::Get.new(
      challenge: Base64.strict_decode64(user.current_challenge),
      rp_id: "www.example.com",
      context: { origin: request.base_url }
    )

    post(
      callback_session_url,
      params: {
        id: Base64.strict_encode64(authenticator.credential_id),
        response: {
          clientDataJSON: Base64.strict_encode64(authenticator.client_data_json),
          signature: Base64.strict_encode64(authenticator.signature),
          userHandle: "user",
          authenticatorData: Base64.strict_encode64(authenticator.authenticator_data)
        }
      }
    )
  end
end
