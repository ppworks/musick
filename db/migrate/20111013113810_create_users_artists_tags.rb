class CreateUsersArtistsTags < ActiveRecord::Migration
  def self.up
    create_table :users_artists_tags do |t|
      t.integer :user_id, :null => false
      t.integer :artist_id, :null => false
      t.integer :tag_id, :null => false

      t.timestamps
    end
    add_index :users_artists_tags, :user_id, :name => 'idx_user_id_on_users_artists_tags'
    add_index :users_artists_tags, :artist_id, :name => 'idx_artist_id_on_users_artists_tags'
    add_index :users_artists_tags, :tag_id, :name => 'idx_tag_id_on_users_artists_tags'
  end

  def self.down
    remove_index :users_artists_tags, :name => 'idx_user_id_on_users_artists_tags'
    remove_index :users_artists_tags, :name => 'idx_artist_id_on_users_artists_tags'
    remove_index :users_artists_tags, :name => 'idx_tag_id_on_users_artists_tags'
    drop_table :users_artists_tags
  end
end
