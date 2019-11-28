# frozen_string_literal: true

class Credential < WebAuthn::ActiveRecord::Credential
  validates :nickname, presence: true
end
