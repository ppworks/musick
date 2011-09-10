class CreateArtistImages < ActiveRecord::Migration
  def self.up
    create_table :artist_images do |t|
      t.integer :artist_id, :null => false
      t.string :original, :null => false
      t.string :large, :null => false
      t.string :largesquare, :null => false
      t.string :medium, :null => false
      t.string :small, :null => false
      t.string :extralarge, :null => false
      t.boolean :show_flg, :null => false, :default => TRUE
      t.timestamps
    end
    add_index :artist_images, [:artist_id, :show_flg], :name => 'idx_artist_id_show_flg_on_artist_images'
  end

  def self.down
    remove_index :artist_images, :name => 'idx_artist_id_show_flg_on_artist_images'
    drop_table :artist_images
  end
end
