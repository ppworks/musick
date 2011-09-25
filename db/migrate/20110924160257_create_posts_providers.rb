class CreatePostsProviders < ActiveRecord::Migration
  def self.up
    create_table :posts_providers do |t|
      t.integer :provider_id, :null => false
      t.integer :post_id, :null => false
      t.string :post_key, :null => false

      t.timestamps
    end
    add_index :posts_providers, ["post_id"], :name => "idx_post_id_on_posts_providers"
    add_index :posts_providers, ["provider_id", "post_id"], :name => "idx_provider_id_post_id_on_posts_providers"
  end

  def self.down
    remove_index :posts_providers, :name => "idx_post_id_on_posts_providers"
    remove_index :posts_providers, :name => "idx_provider_id_post_id_on_posts_providers"
    drop_table :posts_providers
  end
end
