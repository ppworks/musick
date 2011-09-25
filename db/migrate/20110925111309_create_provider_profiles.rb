class CreateProviderProfiles < ActiveRecord::Migration
  def self.up
    create_table :provider_profiles do |t|
      t.integer :provider_id, :null => false
      t.string :user_key, :null => false
      t.string :name, :null => false
      t.string :pic_square, :null => false
      t.string :url, :null => false

      t.timestamps
    end
    add_index :provider_profiles, [:provider_id, :user_key], :name => 'idx_provider_id_user_key_on_provider_profiles', :unique => true
  end

  def self.down
    remove_index :provider_profiles, :name => 'idx_provider_id_user_key_on_provider_profiles'
    drop_table :provider_profiles
  end
end
