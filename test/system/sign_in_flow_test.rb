# frozen_string_literal: true

require "application_system_test_case"
require "webauthn/fake_client"

class SignInFlowTest < ApplicationSystemTestCase
  test "register with human interaction and then sign in" do
    register_user
    # Human uses USB security key

    click_button "account_circle"
    click_on "Sign out"

    sign_in
    # Human uses USB security key

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end

  test "register with fake credentials and then sign in" do
    fake_origin = ENV['WEBAUTHN_ORIGIN']
    fake_client = WebAuthn::FakeClient.new(fake_origin)

    fixed_challenge = SecureRandom.random_bytes(32)
    WebAuthn::CredentialOptions.stub_any_instance :challenge, fixed_challenge do
      fake_credentials = fake_client.create(challenge: fixed_challenge)
      register_user(fake_credentials: fake_credentials)

      click_button "account_circle"
      click_on "Sign out"

      fake_assertion = fake_client.get(challenge: fixed_challenge)
      sign_in(fake_assertion: fake_assertion)
    end

    assert_current_path '/'
    assert_text 'USB key'
    assert_button 'account_circle'
  end
end
