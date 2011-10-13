class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
    add_index :tags, [:name], :name => 'idx_name_on_tags', :unique => true
  end

  def self.down
    remove_index :tags, [:name], :name => 'idx_name_on_tags'
    drop_table :tags
  end
end
