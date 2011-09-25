class CreatePostsComments < ActiveRecord::Migration
  def self.up
    create_table :posts_comments do |t|
      t.integer :post_id, :null => false
      t.integer :user_id
      t.integer :provider_id
      t.string :user_key
      t.string :post_key
      t.text :content, :null => false
      t.integer :posts_comments_likes_count, :null => false, :default => 0

      t.timestamps
    end
    add_index :posts_comments, ["post_id"], :name => "idx_post_id_on_posts_comments"
    add_index :posts_comments, ["user_id"], :name => "idx_user_id_on_posts_comments"
  end

  def self.down
    remove_index :posts_comments, :name => "idx_post_id_on_posts_comments"
    remove_index :posts_comments, :name => "idx_user_id_on_posts_comments"
    drop_table :posts_comments
  end
end
