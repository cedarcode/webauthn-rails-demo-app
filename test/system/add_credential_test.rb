# frozen_string_literal: true

require "application_system_test_case"
require "webauthn/fake_client"

class AddCredentialTest < ApplicationSystemTestCase
  test "add credentials" do
    fake_origin = ENV['WEBAUTHN_ORIGIN']
    fake_client = WebAuthn::FakeClient.new(fake_origin, encoding: false)
    fixed_challenge = SecureRandom.random_bytes(32)

    visit new_registration_path

    fake_credentials = fake_client.create(challenge: fixed_challenge, user_verified: true)
    stub_create(fake_credentials)

    fill_in "registration_username", with: "User1"
    fill_in "Security Key nickname", with: "USB key"

    WebAuthn::PublicKeyCredential::CreationOptions.stub_any_instance :raw_challenge, fixed_challenge do
      click_on "Register using WebAuthn"
      # wait for async response
      assert_button 'account_circle'
    end

    fake_credentials = fake_client.create(challenge: fixed_challenge, user_verified: true)
    stub_create(fake_credentials)

    fill_in("credential_nickname", with: "Touch ID")

    WebAuthn::PublicKeyCredential::CreationOptions.stub_any_instance :raw_challenge, fixed_challenge do
      click_on "Add Security Key"
      # wait for async response
      assert_text 'Touch ID'
    end

    assert_current_path "/"
    assert_text 'USB key'
  end
end
