class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :name, :null => false
      t.boolean :show_flg, :null => false, :default => TRUE
      t.timestamps
    end
    add_index :artists, [:id, :show_flg], :name => 'idx_id_show_flg_on_artists'
  end

  def self.down
    remove_index :artists, :name => 'idx_id_show_flg_on_artists'
    drop_table :artists
  end
end
