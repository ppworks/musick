class CreateUsersArtistItemsTags < ActiveRecord::Migration
  def self.up
    create_table :users_artist_items_tags do |t|
      t.integer :user_id, :null => false
      t.integer :artist_item_id, :null => false
      t.integer :tag_id, :null => false

      t.timestamps
    end
    add_index :users_artist_items_tags, :user_id, :name => 'idx_user_id_on_users_artist_items_tags'
    add_index :users_artist_items_tags, :artist_item_id, :name => 'idx_artist_item_id_on_users_artist_items_tags'
    add_index :users_artist_items_tags, :tag_id, :name => 'idx_tag_id_on_users_artist_items_tags'
  end

  def self.down
    remove_index :users_artist_items_tags, :name => 'idx_user_id_on_users_artist_items_tags'
    remove_index :users_artist_items_tags, :name => 'idx_artist_item_id_on_users_artist_items_tags'
    remove_index :users_artist_items_tags, :name => 'idx_tag_id_on_users_artist_items_tags'
    drop_table :users_artist_items_tags
  end
end
