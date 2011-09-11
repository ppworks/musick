class AddColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string, :null => false, :default => ''
    add_column :users, :image, :string, :null => false, :default => ''
    add_column :users, :default_provider_id, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :image
    remove_column :users, :default_provider_id
  end
end
