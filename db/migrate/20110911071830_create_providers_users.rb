class CreateProvidersUsers < ActiveRecord::Migration
  def self.up
    create_table :providers_users do |t|
      t.integer :provider_id, :null => false
      t.integer :user_id, :null => false
      t.string :user_key, :null => false
      t.string :access_token, :null => false
      t.string :refresh_token
      t.string :secret
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :image

      t.timestamps
    end
    add_index :providers_users, [:provider_id, :user_key], :unique => true, :name => 'idx_provider_id_user_key_on_providers_users'
    add_index :providers_users, [:user_id], :name => 'idx_user_id_on_providers_users'
  end

  def self.down
    remove_index :providers_users, :name => 'idx_provider_id_user_key_on_providers_users'
    remove_index :providers_users, :name => 'idx_user_id_on_providers_users'
    drop_table :providers_users
  end
end
