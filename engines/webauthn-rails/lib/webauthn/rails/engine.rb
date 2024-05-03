require 'webauthn'

module Webauthn
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Webauthn::Rails
    end
  end
end
