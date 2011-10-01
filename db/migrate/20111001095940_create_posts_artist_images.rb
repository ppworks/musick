class CreatePostsArtistImages < ActiveRecord::Migration
  def self.up
    create_table :posts_artist_images do |t|
      t.integer :post_id, :null => false
      t.integer :artist_image_id, :null => false

      t.timestamps
    end
    add_index :posts_artist_images, :post_id, :name => 'idx_post_id_on_posts_artist_images'
    add_index :posts_artist_images, :artist_image_id, :name => 'idx_artist_image_id_on_posts_artist_images'
  end

  def self.down
    remove_index :posts_artist_images, :name => 'idx_post_id_on_posts_artist_images'
    remove_index :posts_artist_images, :name => 'idx_artist_image_id_on_posts_artist_images'
    drop_table :posts_artist_images
  end
end
