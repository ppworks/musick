class AddUniqueIndexToAritstRelations < ActiveRecord::Migration
  def self.up
    add_index :artist_aliases, [:artist_id, :name], :name => 'idx_artist_id_name_on_artist_aliases', :unique => true
    add_index :artist_images, [:artist_id, :original], :name => 'idx_artist_id_original_on_artist_images', :unique => true
  end

  def self.down
    remove_index :artist_aliases, :name => 'idx_artist_id_name_on_artist_aliases'
    remove_index :artist_images, :name => 'idx_artist_id_original_on_artist_images'
  end
end
