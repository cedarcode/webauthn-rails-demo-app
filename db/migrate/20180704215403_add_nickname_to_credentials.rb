class AddNicknameToCredentials < ActiveRecord::Migration[5.2]
  def change
    add_column :credentials, :nickname, :string
  end
end
