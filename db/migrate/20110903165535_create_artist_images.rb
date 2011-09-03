class CreateArtistImages < ActiveRecord::Migration
  def self.up
    create_table :artist_images do |t|
      t.integer :artist_id, :null => false
      t.string :url, :null => false

      t.timestamps
    end
    add_index :artist_images, [:artist_id], :name => 'idx_artist_id_on_artist_images'
  end

  def self.down
    remove_index :artist_images, :name => 'idx_artist_id_on_artist_images'
    drop_table :artist_images
  end
end
