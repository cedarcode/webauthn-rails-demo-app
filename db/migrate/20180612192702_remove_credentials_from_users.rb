# frozen_string_literal: true

class RemoveCredentialsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :credential_id, :string
    remove_column :users, :credential_public_key, :string
  end
end
