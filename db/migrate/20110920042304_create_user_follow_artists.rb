class CreateUserFollowArtists < ActiveRecord::Migration
  def self.up
    create_table :user_follow_artists do |t|
      t.integer :user_id, :null => false
      t.integer :artist_id, :null => false
      t.integer :priority, :null => false, :default => 0
      t.timestamps
    end
    add_index :user_follow_artists, [:user_id, :priority], :name => 'idx_user_id_priority_on_user_follow_artists'
    add_index :user_follow_artists, :artist_id, :name => 'idx_artist_id_on_user_follow_artists'
  end

  def self.down
    remove_index :user_follow_artists, :name => 'idx_user_id_priority_on_user_follow_artists'
    remove_index :user_follow_artists, :name => 'idx_artist_id_on_user_follow_artists'
    drop_table :user_follow_artists
  end
end
