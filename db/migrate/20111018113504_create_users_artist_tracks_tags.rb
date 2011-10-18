class CreateUsersArtistTracksTags < ActiveRecord::Migration
  def self.up
    create_table :users_artist_tracks_tags do |t|
      t.integer :user_id, :null => false
      t.integer :artist_track_id, :null => false
      t.integer :tag_id, :null => false

      t.timestamps
    end
    add_index :users_artist_tracks_tags, :user_id, :name => 'idx_user_id_on_users_artist_tracks_tags'
    add_index :users_artist_tracks_tags, :artist_track_id, :name => 'idx_artist_track_id_on_users_artist_tracks_tags'
    add_index :users_artist_tracks_tags, :tag_id, :name => 'idx_tag_id_on_users_artist_tracks_tags'
  end

  def self.down
    remove_index :users_artist_tracks_tags, :name => 'idx_user_id_on_users_artist_tracks_tags'
    remove_index :users_artist_tracks_tags, :name => 'idx_artist_track_id_on_users_artist_tracks_tags'
    remove_index :users_artist_tracks_tags, :name => 'idx_tag_id_on_users_artist_tracks_tags'
    drop_table :users_artist_tracks_tags
  end
end
