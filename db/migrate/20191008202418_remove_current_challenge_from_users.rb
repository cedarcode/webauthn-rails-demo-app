# frozen_string_literal: true

class RemoveCurrentChallengeFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :current_challenge, :string
  end
end
