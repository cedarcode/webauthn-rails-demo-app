# frozen_string_literal: true

module WebAuthn
  class Ceremony
    attr_reader :user

    def initialize(user)
      @user = user
    end
  end
end
