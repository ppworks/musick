class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string :name

      t.timestamps
    end
    add_index :providers, :name, :name => 'idx_name_on_providers', :unique => true
  end

  def self.down
    remove_index :providers, :name => 'idx_name_on_providers'
    drop_table :providers
  end
end
