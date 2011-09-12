class AddImageSearchedAtToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :image_searched_at, :timestamp
  end

  def self.down
    remove_column :artists, :image_searched_at
  end
end
