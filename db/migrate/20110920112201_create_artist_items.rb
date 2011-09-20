class CreateArtistItems < ActiveRecord::Migration
  def self.up
    create_table :artist_items do |t|
      t.integer :artist_id, :null => false
      t.string :asin, :null => false
      t.string :ean
      t.string :title, :null => false
      t.string :detail_page_url, :null =>false
      t.string :small_image_url
      t.string :medium_image_url
      t.string :large_image_url
      t.string :label
      t.string :product_group
      t.string :format
      t.date :release_date

      t.timestamps
    end
    add_index :artist_items, [:artist_id, :asin], :name => 'idx_artist_id_asin_on_artist_items'
  end

  def self.down
    remove_index :artist_items, :name => 'idx_artist_id_asin_on_artist_items'
    drop_table :artist_items
  end
end
