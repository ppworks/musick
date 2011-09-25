class CreatePostsLikes < ActiveRecord::Migration
  def self.up
    create_table :posts_likes do |t|
      t.integer :post_id, :null => false
      t.integer :user_id
      t.integer :provider_id
      t.string :user_key
      t.string :post_key

      t.timestamps
    end
    add_index :posts_likes, ["post_id"], :name => "idx_post_id_on_posts_likes"
    add_index :posts_likes, ["provider_id", "post_id"], :name => "idx_provider_id_post_id_on_posts_likes"
  end

  def self.down
    remove_index :posts_likes, :name => "idx_post_id_on_posts_likes"
    remove_index :posts_likes, :name => "idx_provider_id_post_id_on_posts_likes"
    drop_table :posts_likes
  end
end
