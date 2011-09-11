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

ActiveRecord::Schema.define(:version => 20110907142526) do

  create_table "artist_aliases", :force => true do |t|
    t.integer  "artist_id",  :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_aliases", ["artist_id", "name"], :name => "idx_artist_id_name_on_artist_aliases", :unique => true
  add_index "artist_aliases", ["artist_id"], :name => "idx_artist_id_on_artist_aliases"

  create_table "artist_images", :force => true do |t|
    t.integer  "artist_id",                     :null => false
    t.string   "original",                      :null => false
    t.string   "large",                         :null => false
    t.string   "largesquare",                   :null => false
    t.string   "medium",                        :null => false
    t.string   "small",                         :null => false
    t.string   "extralarge",                    :null => false
    t.boolean  "show_flg",    :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_images", ["artist_id", "original"], :name => "idx_artist_id_original_on_artist_images", :unique => true
  add_index "artist_images", ["artist_id", "show_flg"], :name => "idx_artist_id_show_flg_on_artist_images"

  create_table "artist_lastfms", :force => true do |t|
    t.integer  "artist_id",  :null => false
    t.string   "mbid"
    t.string   "url"
    t.text     "summary"
    t.text     "content"
    t.string   "main_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_lastfms", ["artist_id"], :name => "idx_artist_id_on_artist_lastfms", :unique => true
  add_index "artist_lastfms", ["url"], :name => "idx_url_on_artist_lastfms"

  create_table "artists", :force => true do |t|
    t.string   "name",                         :null => false
    t.boolean  "show_flg",   :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artists", ["id", "show_flg"], :name => "idx_id_show_flg_on_artists"

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "providers", ["name"], :name => "idx_name_on_providers", :unique => true

end
