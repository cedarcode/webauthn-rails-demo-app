# frozen_string_literal: true

require "application_system_test_case"
require "webauthn/fake_client"

class AddCredentialFlowTest < ApplicationSystemTestCase
  test "add credentials" do
    fake_origin = ENV['WEBAUTHN_ORIGIN']
    fake_client = WebAuthn::FakeClient.new(fake_origin)

    fixed_challenge = SecureRandom.random_bytes(32)
    WebAuthn::CredentialCreationOptions.stub_any_instance :challenge, fixed_challenge do
      fake_credentials = fake_client.create(challenge: fixed_challenge)
      register_user(fake_credentials: fake_credentials)
    end

    fixed_challenge = SecureRandom.random_bytes(32)
    WebAuthn::CredentialCreationOptions.stub_any_instance :challenge, fixed_challenge do
      fake_credentials = fake_client.create(challenge: fixed_challenge)
      stub_create(fake_credentials)

      fill_in("credential_nickname", with: "Touch ID")
      click_on "Add Credential"
      wait_for_async_request
    end

    assert_text 'Touch ID'
    assert_text 'USB key'
  end
end
