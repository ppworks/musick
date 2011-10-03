class CreateUserAccessLogs < ActiveRecord::Migration
  def self.up
    create_table :user_access_logs do |t|
      t.integer :user_id, :null => false
      t.integer :kind, :null => false

      t.timestamps
    end
    add_index :user_access_logs, :user_id, :name => 'idx_user_id_on_user_access_logs'
  end

  def self.down
    remove_index :user_access_logs, :name => 'idx_user_id_on_user_access_logs'
    drop_table :user_access_logs
  end
end
