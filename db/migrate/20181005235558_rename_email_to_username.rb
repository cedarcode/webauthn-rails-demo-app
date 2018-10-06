# frozen_string_literal: true

class RenameEmailToUsername < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :email, :username
  end
end
