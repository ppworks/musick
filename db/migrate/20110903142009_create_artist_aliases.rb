class CreateArtistAliases < ActiveRecord::Migration
  def self.up
    create_table :artist_aliases do |t|
      t.integer :artist_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    add_index :artist_aliases, [:artist_id], :name => 'idx_artist_id_on_artist_aliases'
  end

  def self.down
    remote_index :artist_aliases, :name => 'idx_artist_id_on_artist_aliases'
    drop_table :artist_aliases
  end
end
