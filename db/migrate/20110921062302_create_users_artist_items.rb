class CreateUsersArtistItems < ActiveRecord::Migration
  def self.up
    create_table :users_artist_items do |t|
      t.integer :user_id, :null => false
      t.integer :artist_item_id, :null => false
      t.integer :priority, :null => false, :default => 0
      t.timestamps
    end
    add_index :users_artist_items, [:user_id, :priority], :name => 'idx_user_id_priority_on_users_artist_items'
    add_index :users_artist_items, [:user_id, :artist_item_id], :name => 'idx_user_id_artist_item_id_on_users_artist_items', :unique => true
    add_index :users_artist_items, :artist_item_id, :name => 'idx_artist_item_id_on_users_artist_items'
  end

  def self.down
    remove_index :users_artist_items, :name => 'idx_user_id_priority_on_users_artist_items'
    remove_index :users_artist_items, :name => 'idx_user_id_artist_item_id_on_users_artist_items'
    remove_index :users_artist_items, :name => 'idx_artist_item_id_on_users_artist_items'
    drop_table :users_artist_items
  end
end
