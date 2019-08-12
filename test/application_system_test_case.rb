# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: (ENV["TEST_BROWSER"] || :chrome).to_sym, screen_size: [1400, 1400]

  setup do
    Capybara.app_host = ENV['WEBAUTHN_ORIGIN']
    Capybara.server_host = "localhost"
    Capybara.server_port = 3030
    Capybara.default_max_wait_time = 20
  end
end
