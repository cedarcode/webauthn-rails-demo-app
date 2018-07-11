# frozen_string_literal: true

class User < ApplicationRecord
  CREDENTIAL_MIN_AMOUNT = 1

  has_many :credentials, dependent: :destroy

  def can_delete_credentials?
    credentials.size > CREDENTIAL_MIN_AMOUNT
  end
end
