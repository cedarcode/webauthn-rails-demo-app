# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def stub_create(fake_credentials)
    fake_credentials = camelize_keys(fake_credentials)

    # Encode binary fields to use in script
    encode(fake_credentials, :rawId)
    encode(fake_credentials[:response], :attestationObject)

    # Parse to avoid escaping already escaped characters
    fake_credentials[:response][:clientDataJSON] = JSON.parse(fake_credentials[:response][:clientDataJSON])

    fake_credentials = fake_credentials.to_json

    script =
      "var credential = JSON.parse('" + fake_credentials + "');
       credential['rawId'] = Uint8Array.from(atob(credential['rawId']), c => c.charCodeAt(0));
       credential['response']['attestationObject'] =
         Uint8Array.from(atob(credential['response']['attestationObject']), c => c.charCodeAt(0));
       credential['response']['clientDataJSON'] =
         Uint8Array.from(JSON.stringify(credential['response']['clientDataJSON']), c => c.charCodeAt(0));
       var stub = window.sinon.stub(navigator.credentials, 'create').resolves(credential);"
    page.execute_script(script)
  end

  def stub_get(fake_assertion)
    fake_assertion = camelize_keys(fake_assertion)

    # Encode binary fields to use in script
    encode(fake_assertion, :rawId)
    encode(fake_assertion[:response], :authenticatorData)
    encode(fake_assertion[:response], :signature)

    # Parse to avoid escaping already escaped characters
    fake_assertion[:response][:clientDataJSON] = JSON.parse(fake_assertion[:response][:clientDataJSON])

    fake_assertion = fake_assertion.to_json
    script =
      "var assertion = JSON.parse('" + fake_assertion + "');
       assertion['rawId'] = Uint8Array.from(atob(assertion['rawId']), c => c.charCodeAt(0));
       assertion['response']['authenticatorData'] =
        Uint8Array.from(atob(assertion['response']['authenticatorData']), c => c.charCodeAt(0));
       assertion['response']['clientDataJSON'] =
        Uint8Array.from(JSON.stringify(assertion['response']['clientDataJSON']), c => c.charCodeAt(0));
       assertion['response']['signature'] =
        Uint8Array.from(atob(assertion['response']['signature']), c => c.charCodeAt(0));
       var stub = window.sinon.stub(navigator.credentials, 'get').resolves(assertion);"
    page.execute_script(script)
  end

  def camelize_keys(hash)
    hash.deep_transform_keys do |key|
      if key == :client_data_json
        :clientDataJSON
      else
        key.to_s.camelize(:lower).to_sym
      end
    end
  end

  def encode(hash, key)
    hash[key] = Base64.strict_encode64(hash[key])
  end
end
