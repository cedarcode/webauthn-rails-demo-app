# frozen_string_literal: true

class CreateCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :credentials do |t|
      t.string :external_id
      t.string :public_key
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
