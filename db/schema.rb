# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110904141029) do

  create_table "artist_aliases", :force => true do |t|
    t.integer  "artist_id",  :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_aliases", ["artist_id", "name"], :name => "idx_artist_id_name_on_artist_aliases", :unique => true
  add_index "artist_aliases", ["artist_id"], :name => "idx_artist_id_on_artist_aliases"

  create_table "artist_images", :force => true do |t|
    t.integer  "artist_id",  :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_images", ["artist_id", "url"], :name => "idx_artist_id_url_on_artist_images", :unique => true
  add_index "artist_images", ["artist_id"], :name => "idx_artist_id_on_artist_images"

  create_table "artist_lastfms", :force => true do |t|
    t.integer  "artist_id",  :null => false
    t.string   "mbid",       :null => false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_lastfms", ["artist_id"], :name => "idx_artist_id_on_artist_lastfms", :unique => true
  add_index "artist_lastfms", ["mbid"], :name => "idx_mbid_on_artist_lastfms"

  create_table "artists", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
