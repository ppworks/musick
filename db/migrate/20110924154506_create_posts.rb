class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id, :null => false
      t.text :content, :null => false
      t.integer :posts_likes_count, :null => false, :default => 0
      t.boolean :show_flg, :null => false, :default => true
      t.datetime :synced_at

      t.timestamps
    end
    add_index :posts, ["user_id", "show_flg"], :name => "idx_user_id_show_flg_on_posts"
  end

  def self.down
    remove_index :posts, :name => "idx_user_id_show_flg_on_posts"
    drop_table :posts
  end
end
