class CreateUsersArtists < ActiveRecord::Migration
  def self.up
    create_table :users_artists do |t|
      t.integer :user_id, :null => false
      t.integer :artist_id, :null => false
      t.integer :priority, :null => false, :default => 0
      t.timestamps
    end
    add_index :users_artists, [:user_id, :priority], :name => 'idx_user_id_priority_on_users_artists'
    add_index :users_artists, [:user_id, :artist_id], :name => 'idx_user_id_artist_id_on_users_artists', :unique => true
    add_index :users_artists, :artist_id, :name => 'idx_artist_id_on_users_artists'
  end

  def self.down
    remove_index :users_artists, :name => 'idx_user_id_priority_on_users_artists'
    remove_index :users_artists, :name => 'idx_user_id_artist_id_on_users_artists'
    remove_index :users_artists, :name => 'idx_artist_id_on_users_artists'
    drop_table :users_artists
  end
end
