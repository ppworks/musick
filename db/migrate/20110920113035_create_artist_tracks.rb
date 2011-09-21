class CreateArtistTracks < ActiveRecord::Migration
  def self.up
    create_table :artist_tracks do |t|
      t.integer :artist_id, :null => false
      t.integer :artist_item_id, :null => false
      t.integer :disc, :null => false, :default => 1
      t.integer :track, :null => false
      t.string :title, :null => false

      t.timestamps
    end
    add_index :artist_tracks, :artist_id, :name => 'idx_artist_id_on_artist_tracks'
    add_index :artist_tracks, :artist_item_id, :name => 'idx_artist_item_id_on_artist_tracks'
  end

  def self.down
    remove_index :artist_tracks, :name => 'idx_artist_id_on_artist_tracks'
    remove_index :artist_tracks, :name => 'idx_artist_item_id_on_artist_tracks'
    drop_table :artist_tracks
  end
end
