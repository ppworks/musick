class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :user_id, :null => false
      t.string :message
      t.integer :to_provider_id, :null => false
      t.integer :to_invite_kind
      t.string :to_user_key, :null => false
      t.integer :to_user_id
      t.datetime :delivered_at
      t.timestamps
    end
    add_index :invites, [:user_id, :to_provider_id, :to_user_key], :name => 'idx_user_id_to_provider_id_to_user_key_on_invites'
  end

  def self.down
    remove_index :invites, :name => 'idx_user_id_to_provider_id_to_user_key_on_invites'
    drop_table :invites
  end
end
