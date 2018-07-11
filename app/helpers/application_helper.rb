# frozen_string_literal: true

module ApplicationHelper
  def unsupported_browser_message
    user_agent = UserAgent.parse(request.user_agent)

    supported_browsers_message = "Use Chrome for Desktop 67+ or Firefox for Desktop 60+"

    if user_agent.mobile?
      "WebAuthn isn't yet supported for mobile web browsers. #{supported_browsers_message}."
    elsif user_agent.browser == "Chrome"
      if user_agent.version < "67"
        "Upgrade Google Chrome up to version 67 or more for the demo to work"
      end
    elsif user_agent.browser == "Firefox"
      if user_agent.version < "60"
        "Upgrade Firefox up to version 60 or more for the demo to work"
      end
    elsif user_agent.browser == "Edge"
      "Microsoft Edge isn't supported for this demo, we're sorry. #{supported_browsers_message}."
    else
      "#{user_agent.platform} #{user_agent.browser} #{user_agent.version} doesn't support WebAuthn API yet.
      #{supported_browsers_message}."
    end
  end
end
