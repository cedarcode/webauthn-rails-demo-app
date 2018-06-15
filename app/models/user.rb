class User < ApplicationRecord
  has_many :credentials, dependent: :destroy
end
