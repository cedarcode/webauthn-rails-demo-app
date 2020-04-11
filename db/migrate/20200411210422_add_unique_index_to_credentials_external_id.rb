# frozen_string_literal: true

class AddUniqueIndexToCredentialsExternalId < ActiveRecord::Migration[6.0]
  def change
    add_index :credentials, :external_id, unique: true
  end
end
