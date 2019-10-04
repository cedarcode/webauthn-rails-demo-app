# frozen_string_literal: true

require 'test_helper'
require "webauthn/fake_client"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should initiate registration successfully" do
    post registration_url, params: { registration: { username: "alice" }, format: :json }

    assert_response :success
  end

  test "should return error if registrating taken username" do
    User.create!(username: "alice")

    post registration_url, params: { registration: { username: "alice" }, format: :json }

    assert_response :unprocessable_entity
    assert_equal ["Username has already been taken"], JSON.parse(response.body)["errors"]
  end

  test "should return error if registrating blank username" do
    post registration_url, params: { registration: { username: "" }, format: :json }

    assert_response :unprocessable_entity
    assert_equal ["Username can't be blank"], JSON.parse(response.body)["errors"]
  end

  test "should return error if registering existing credential" do
    raw_challenge = SecureRandom.random_bytes(32)
    challenge = WebAuthn.configuration.encoder.encode(raw_challenge)

    WebAuthn::PublicKeyCredential::CreationOptions.stub_any_instance(:raw_challenge, raw_challenge) do
      post registration_url, params: { registration: { username: "alice" }, format: :json }

      assert_response :success
    end

    public_key_credential = WebAuthn::FakeClient.new(ENV["WEBAUTHN_ORIGIN"]).create(challenge: challenge)
    webauthn_credential = WebAuthn::Credential.from_create(public_key_credential)

    User.create!(
      username: "bob",
      credentials: [
        Credential.new(
          external_id: Base64.strict_encode64(webauthn_credential.raw_id),
          nickname: "Bob's USB Key",
          public_key: webauthn_credential.public_key,
          sign_count: webauthn_credential.sign_count
        )
      ]
    )

    post(
      callback_registration_url,
      params: { credential_nickname: "USB Key" }.merge(public_key_credential)
    )

    assert_response :unprocessable_entity
    assert_equal "Couldn't register your Security Key", response.body
  end
end
