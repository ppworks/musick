class AddColumnToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :is_public, :boolean, :default => TRUE
    add_column :tags, :counter, :integer, :default => 0, :null => false
    add_column :tags, :kind, :integer, :null => false
    remove_column :tags, :name
    add_column :tags, :name_ja, :string
    add_column :tags, :name_en, :string
  end

  def self.down
    remove_column :tags, :is_public
    remove_column :tags, :counter
    remove_column :tags, :kind
    add_column :tags, :name, :string, :null => false
    remove_column :tags, :name_ja
    remove_column :tags, :name_en
  end
end
