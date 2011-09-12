class AddColumnsToArtistLastfms < ActiveRecord::Migration
  def self.up
    add_column :artist_lastfms, :thumbnail_image, :string
  end

  def self.down
    remove_column :artist_lastfms, :thumbnail_image
  end
end
