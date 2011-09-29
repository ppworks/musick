class CreatePostsArtistTracks < ActiveRecord::Migration
  def self.up
    create_table :posts_artist_tracks do |t|
      t.integer :post_id, :null => false
      t.integer :artist_track_id, :null => false

      t.timestamps
    end
    add_index :posts_artist_tracks, :post_id, :name => 'idx_post_id_on_posts_artist_tracks'
    add_index :posts_artist_tracks, :artist_track_id, :name => 'idx_artist_track_id_on_posts_artist_tracks'
  end

  def self.down
    remove_index :posts_artist_tracks, :post_id, :name => 'idx_post_id_on_posts_artist_tracks'
    remove_index :posts_artist_tracks, :artist_track_id, :name => 'idx_artist_track_id_on_posts_artist_tracks'
    drop_table :posts_artist_tracks
  end
end
