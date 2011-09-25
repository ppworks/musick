class CreatePostsUserActions < ActiveRecord::Migration
  def self.up
    create_table :posts_user_actions do |t|
      t.integer :post_id, :null => false
      t.integer :user_action_id, :null => false
      t.string :target_attributes, :null => false
      t.string :target_name, :null => false

      t.timestamps
    end
    add_index :posts_user_actions, [:post_id], :name => 'idx_post_id_on_posts_user_actions', :unique => true
  end

  def self.down
    remove_index :posts_user_actions, :name => 'idx_post_id_on_posts_user_actions', :unique => true
    drop_table :posts_user_actions
  end
end
