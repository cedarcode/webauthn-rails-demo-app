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
    assert_equal ["Username has already been taken"], response.parsed_body["errors"]
  end

  test "should return error if registrating blank username" do
    post registration_url, params: { registration: { username: "" }, format: :json }

    assert_response :unprocessable_entity
    assert_equal ["Username can't be blank"], response.parsed_body["errors"]
  end

  test "should return error if registering existing credential" do
    raw_challenge = SecureRandom.random_bytes(32)
    challenge = WebAuthn.configuration.encoder.encode(raw_challenge)

    WebAuthn::PublicKeyCredential::CreationOptions.stub_any_instance(:raw_challenge, raw_challenge) do
      post registration_url, params: { registration: { username: "alice" }, format: :json }

      assert_response :success
    end

    public_key_credential =
      WebAuthn::FakeClient
      .new(Rails.configuration.webauthn_origin)
      .create(challenge:, user_verified: true)

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

    assert_no_difference -> { User.count } do
      post(
        callback_registration_url,
        params: { credential_nickname: "USB Key" }.merge(public_key_credential)
      )
    end

    assert_response :unprocessable_entity
    assert_equal "Couldn't register your Security Key", response.body
  end

  test "should register successfully" do
    authenticator = WebAuthn::FakeAuthenticator.new

    fake_rp = WebAuthn::RelyingParty.new(
      origin: "https://fake.relying_party.test",
      id: "fake.relying_party.test",
      name: "Fake RelyingParty"
    )

    fake_client = WebAuthn::FakeClient.new("https://fake.relying_party.test", authenticator:)

    user = User.new(username: "John Doe")

    raw_challenge = SecureRandom.random_bytes(32)
    challenge = WebAuthn.configuration.encoder.encode(raw_challenge)

    webauthn_credential = fake_client.create(challenge:, rp_id: fake_rp.id, user_verified: true)

    session_data = {
      current_registration: {
        challenge:,
        user_attributes: user.attributes
      }
    }

    any_instance_of(RegistrationsController) do |klass|
      stub(klass).session { session_data }
    end

    any_instance_of(ApplicationController) do |klass|
      stub(klass).relying_party { fake_rp }
    end

    assert_difference 'User.count', +1 do
      assert_difference 'Credential.count', +1 do
        post(
          callback_registration_url,
          params: { credential_nickname: "USB Key" }.merge(webauthn_credential)
        )
      end
    end

    assert_response :success
  end
end
