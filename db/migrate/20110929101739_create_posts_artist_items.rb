class CreatePostsArtistItems < ActiveRecord::Migration
  def self.up
    create_table :posts_artist_items do |t|
      t.integer :post_id, :null => false
      t.integer :artist_item_id, :null => false

      t.timestamps
    end
    add_index :posts_artist_items, :post_id, :name => 'idx_post_id_on_posts_artist_items'
    add_index :posts_artist_items, :artist_item_id, :name => 'idx_artist_item_id_on_posts_artist_items'
  end

  def self.down
    remove_index :posts_artist_items, :name => 'idx_post_id_on_posts_artist_items'
    remove_index :posts_artist_items, :name => 'idx_artist_item_id_on_posts_artist_items'
    drop_table :posts_artist_items
  end
end
