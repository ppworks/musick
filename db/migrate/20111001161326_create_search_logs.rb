class CreateSearchLogs < ActiveRecord::Migration
  def self.up
    create_table :search_logs do |t|
      t.integer :user_id
      t.string :keyword
      t.string :kind
      t.integer :target_id

      t.timestamps
    end
    add_index :search_logs, :user_id, :name => 'idx_user_id_on_search_logs'
    add_index :search_logs, [:kind, :target_id], :name => 'idx_kind_target_id_on_search_logs'
  end

  def self.down
    remove_index :search_logs, :name => 'idx_user_id_on_search_logs'
    remove_index :search_logs, :name => 'idx_kind_target_id_on_search_logs'
    drop_table :search_logs
  end
end
