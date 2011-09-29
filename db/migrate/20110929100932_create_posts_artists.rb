class CreatePostsArtists < ActiveRecord::Migration
  def self.up
    create_table :posts_artists do |t|
      t.integer :post_id, :null => false
      t.integer :artist_id, :null => false

      t.timestamps
    end
    add_index :posts_artists, :post_id, :name => 'idx_post_id_on_posts_artists'
    add_index :posts_artists, :artist_id, :name => 'idx_artist_id_on_posts_artists'
  end

  def self.down
    remove_index :posts_artists, :name => 'idx_post_id_on_posts_artists'
    remove_index :posts_artists, :name => 'idx_artist_id_on_posts_artists'
    drop_table :posts_artists
  end
end
