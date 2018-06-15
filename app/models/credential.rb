class Credential < ApplicationRecord
  validates :raw_id, :public_key, presence: true
end
