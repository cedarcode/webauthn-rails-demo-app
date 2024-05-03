class CreateWebauthnRailsCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :webauthn_rails_credentials do |t|
      t.string :external_id
      t.string :public_key
      t.string :nickname
      t.bigint :sign_count
      t.integer :user_id

      t.timestamps
    end
  end
end
