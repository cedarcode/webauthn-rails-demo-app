# frozen_string_literal: true

class AddPublicKeyToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.rename :credential, :credential_id
      t.string :credential_public_key
    end
  end
end
