# frozen_string_literal: true

class User < ApplicationRecord
  has_many :credentials, dependent: :destroy
end
