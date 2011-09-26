class CreateUserActions < ActiveRecord::Migration
  def self.up
    create_table :user_actions do |t|
      t.string :name, :null => false
      t.string :target, :null => false

      t.timestamps
    end
    add_index :user_actions, [:name, :target], :name => 'idx_name_target_on_user_actions', :unique => true
  end

  def self.down
    remove_index :user_actions, :name => 'idx_name_target_on_user_actions'
    drop_table :user_actions
  end
end
