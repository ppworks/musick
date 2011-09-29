class CreatePostErrors < ActiveRecord::Migration
  def self.up
    create_table :post_errors do |t|
      t.integer :post_id, :null => false
      t.integer :provider_id, :null => false
      t.integer :user_id, :null => false
      t.text :error_message, :null => false

      t.timestamps
    end
    add_index :post_errors, :user_id, :name => 'idx_user_id_on_post_errors'
  end

  def self.down
    remove_index :post_errors, :name => 'idx_user_id_on_post_errors'
    drop_table :post_errors
  end
end
