# frozen_string_literal: true

class AddWebauthnIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :webauthn_id, :string
  end
end
