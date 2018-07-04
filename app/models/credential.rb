# frozen_string_literal: true

class Credential < ApplicationRecord
  validates :external_id, :public_key, :nickname, presence: true
end
