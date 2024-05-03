require "webauthn/rails/version"
require "webauthn/rails/engine"

module Webauthn
  module Rails

    module Controllers
      autoload :Helpers, 'webauthn/rails/controllers/helpers'
    end

    mattr_accessor :webauthn_origin

    def self.configure
      yield self
    end

  end
end
