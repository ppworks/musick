class CreateArtistLastfms < ActiveRecord::Migration
  def self.up
    create_table :artist_lastfms do |t|
      t.integer :artist_id, :null => false
      t.string :mbid, :null => true
      t.string :url
      t.text :summary
      t.text :content
      t.string :main_image

      t.timestamps
    end
    add_index :artist_lastfms, :artist_id, :name => 'idx_artist_id_on_artist_lastfms', :unique => true
    add_index :artist_lastfms, :url, :name => 'idx_url_on_artist_lastfms'
  end

  def self.down
    remove_index :artist_lastfms, :name => 'idx_artist_id_on_artist_lastfms', :unique => true
    remove_index :artist_lastfms, :name => 'idx_url_on_artist_lastfms'
    drop_table :artist_lastfms
  end
end
