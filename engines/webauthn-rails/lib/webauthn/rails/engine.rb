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
    end
  end
end
