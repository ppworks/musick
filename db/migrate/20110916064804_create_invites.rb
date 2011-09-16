class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :user_id
      t.string :message
      t.integer :to_provider_id
      t.string :to_user_key
      t.integer :to_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
