require 'webauthn'

module Webauthn
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Webauthn::Rails

      initializer "webauthn-rails.helpers" do
        ActiveSupport.on_load(:action_controller) do
          include Webauthn::Rails::Controllers::Helpers
        end
      end

      initializer "webautn-rails.assets" do
        if ::Rails.application.config.respond_to?(:assets)
          ::Rails.application.config.assets.precompile += %w( credential.js )
        end
      end
    end
  end
end
