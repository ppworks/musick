class CreateUsersArtistTracks < ActiveRecord::Migration
  def self.up
    create_table :users_artist_tracks do |t|
      t.integer :user_id, :null => false
      t.integer :artist_track_id, :null => false
      t.integer :priority, :null => false, :default => 0
      t.timestamps
    end
    add_index :users_artist_tracks, [:user_id, :priority], :name => 'idx_user_id_priority_on_users_artist_tracks'
    add_index :users_artist_tracks, [:user_id, :artist_track_id], :name => 'idx_user_id_artist_track_id_on_users_artist_tracks', :unique => true
    add_index :users_artist_tracks, :artist_track_id, :name => 'idx_artist_track_id_on_users_artist_tracks'
  end

  def self.down
    remove_index :users_artist_tracks, :name => 'idx_user_id_priority_on_users_artist_tracks'
    remove_index :users_artist_tracks, :name => 'idx_user_id_artist_track_id_on_users_artist_tracks'
    remove_index :users_artist_tracks, :name => 'idx_artist_track_id_on_users_artist_tracks'
    drop_table :users_artist_tracks
  end
end
