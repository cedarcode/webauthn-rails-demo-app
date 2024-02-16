class AddAdditionalFieldsToCredentials < ActiveRecord::Migration[7.0]
  def change
    add_column :credentials, :uv_initialized, :boolean, null: false, default: false
    add_column :credentials, :transports, :string, array: true, null: true
    add_column :credentials, :backup_eligible, :boolean, null: false, default: false
    add_column :credentials, :backup_state, :boolean, null: false, default: false
  end
end
