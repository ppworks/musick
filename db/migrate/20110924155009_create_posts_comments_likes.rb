class CreatePostsCommentsLikes < ActiveRecord::Migration
  def self.up
    create_table :posts_comments_likes do |t|
      t.integer :posts_comment_id, :null => false
      t.integer :user_id
      t.integer :provider_id
      t.string :user_key
      t.string :post_key

      t.timestamps
    end
    add_index :posts_comments_likes, ["posts_comment_id"], :name => "idx_posts_comment_id_on_posts_comments_likes"
    add_index :posts_comments_likes, ["provider_id", "posts_comment_id"], :name => "idx_provider_id_posts_comment_id_posts_comments_likes"
  end

  def self.down
    remove_index :posts_comments_likes, :name => "idx_posts_comment_id_on_posts_comments_likes"
    remove_index :posts_comments_likes, :name => "idx_provider_id_posts_comment_id_posts_comments_likes"

    drop_table :posts_comments_likes
  end
end
