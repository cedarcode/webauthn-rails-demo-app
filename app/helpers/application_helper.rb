# frozen_string_literal: true

module ApplicationHelper
  Browser = Struct.new(:browser, :version, :mobile)

  TESTED_BROWSERS = [
    Browser.new("Firefox", "60", false),
    Browser.new("Chrome", "67", false),
    Browser.new("Chrome", "70", true),
    Browser.new("Edge", "18", false),
  ].freeze

  def unsupported_browser_message
    user_agent = UserAgent.parse(request.user_agent)

    if TESTED_BROWSERS.none? { |browser| browser.mobile == user_agent.mobile? && user_agent >= browser }
      "This demo was not explicitly tested with this user agent. It may work anyways."
    end
  end
end
