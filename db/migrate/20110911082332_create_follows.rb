class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :other_user_id, :null => false
    end
    add_index :follows, [:user_id, :other_user_id], :name => 'idx_user_id_other_user_id_on_follows', :unique => true
    add_index :follows, [:other_user_id, :user_id], :name => 'idx_other_user_id_user_id_on_follows', :unique => true
  end

  def self.down
    remove_index :follows, :name => 'idx_user_id_other_user_id_on_follows'
    remove_index :follows, :name => 'idx_other_user_id_user_id_on_follows'
    drop_table :follows
  end
end
