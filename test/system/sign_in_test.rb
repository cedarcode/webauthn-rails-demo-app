# frozen_string_literal: true

require "application_system_test_case"
require "webauthn/fake_client"

class SignInTest < ApplicationSystemTestCase
  test "register and then sign in" do
    fake_origin = ENV['WEBAUTHN_ORIGIN']
    fake_client = WebAuthn::FakeClient.new(fake_origin, encoding: false)
    fixed_challenge = SecureRandom.random_bytes(32)

    visit new_registration_path

    fake_credentials = fake_client.create(challenge: fixed_challenge)
    stub_create(fake_credentials)

    fill_in "registration_username", with: "User1"
    fill_in "Security Key nickname", with: "USB key"

    WebAuthn::PublicKeyCredential::CreationOptions.stub_any_instance :raw_challenge, fixed_challenge do
      click_on "Register using WebAuthn"
      # wait for async response
      assert_button "account_circle"
    end

    click_button "account_circle"
    click_on "Sign out"
    visit new_session_path

    fake_assertion = fake_client.get(challenge: fixed_challenge)
    stub_get(fake_assertion)

    fill_in "Username", with: "User1"

    WebAuthn::PublicKeyCredential::RequestOptions.stub_any_instance :raw_challenge, fixed_challenge do
      click_button "Sign in using WebAuthn"
      # wait for async response
      assert_button "account_circle"
    end

    assert_current_path "/"
    assert_text 'USB key'
  end
end
