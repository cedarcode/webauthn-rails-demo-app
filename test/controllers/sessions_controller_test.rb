# frozen_string_literal: true

require 'test_helper'
require "webauthn/fake_client"

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

  def create_credential(client: WebAuthn::FakeClient.new, rp_id: nil)
    rp_id ||= URI.parse(client.origin).host

    create_result = client.create(rp_id: rp_id)

    credential_public_key =
      WebAuthn::AuthenticatorAttestationResponse
      .new(create_result[:response])
      .credential
      .public_key

    [create_result[:id], credential_public_key]
  end

  test "callback works" do
    user = User.create!(username: "alice")

    origin = "http://www.example.com"
    rp_id = URI.parse(origin).host

    client = WebAuthn::FakeClient.new(origin)
    credential_id, credential_public_key = create_credential(client: client, rp_id: rp_id)

    user.credentials.create!(
      nickname: "credential",
      external_id: Base64.strict_encode64(credential_id),
      public_key: Base64.strict_encode64(credential_public_key)
    )

    post session_url, params: { session: { username: "alice" }, format: :json }

    user.reload

    get_result = client.get(challenge: Base64.strict_decode64(user.current_challenge), rp_id: rp_id)

    post(
      callback_session_url,
      params: {
        id: Base64.strict_encode64(get_result[:id]),
        response: {
          clientDataJSON: Base64.strict_encode64(get_result[:response][:client_data_json]),
          signature: Base64.strict_encode64(get_result[:response][:signature]),
          userHandle: "user",
          authenticatorData: Base64.strict_encode64(get_result[:response][:authenticator_data])
        }
      }
    )
  end
end
