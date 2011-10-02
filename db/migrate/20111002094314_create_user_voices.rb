class CreateUserVoices < ActiveRecord::Migration
  def self.up
    create_table :user_voices do |t|
      t.integer :user_id
      t.text :message
      t.string :ip_address
      t.string :path
      t.string :referer

      t.timestamps
    end
  end

  def self.down
    drop_table :user_voices
  end
end
