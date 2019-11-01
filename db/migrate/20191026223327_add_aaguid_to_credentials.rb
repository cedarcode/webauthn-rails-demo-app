class AddAaguidToCredentials < ActiveRecord::Migration[6.0]
  def change
    add_column :credentials, :aaguid, :string
    add_column :credentials, :u2f_key_id, :string
  end
end
