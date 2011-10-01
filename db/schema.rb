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

ActiveRecord::Schema.define(:version => 20111001161326) do

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

  create_table "artist_items", :force => true do |t|
    t.integer  "artist_id",        :null => false
    t.string   "asin",             :null => false
    t.string   "ean"
    t.string   "title",            :null => false
    t.string   "detail_page_url",  :null => false
    t.string   "small_image_url"
    t.string   "medium_image_url"
    t.string   "large_image_url"
    t.string   "label"
    t.string   "product_group"
    t.string   "format"
    t.date     "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_items", ["artist_id", "asin"], :name => "idx_artist_id_asin_on_artist_items"

  create_table "artist_lastfms", :force => true do |t|
    t.integer  "artist_id",       :null => false
    t.string   "mbid"
    t.string   "url"
    t.text     "summary"
    t.text     "content"
    t.string   "main_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_image"
  end

  add_index "artist_lastfms", ["artist_id"], :name => "idx_artist_id_on_artist_lastfms", :unique => true
  add_index "artist_lastfms", ["url"], :name => "idx_url_on_artist_lastfms"

  create_table "artist_tracks", :force => true do |t|
    t.integer  "artist_id",                     :null => false
    t.integer  "artist_item_id",                :null => false
    t.string   "asin"
    t.integer  "disc",           :default => 1, :null => false
    t.integer  "track",                         :null => false
    t.string   "title",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_tracks", ["artist_id", "asin", "disc", "track"], :name => "idx_artist_id_asin_disc_track_on_artist_tracks", :unique => true
  add_index "artist_tracks", ["artist_id"], :name => "idx_artist_id_on_artist_tracks"
  add_index "artist_tracks", ["artist_item_id"], :name => "idx_artist_item_id_on_artist_tracks"

  create_table "artists", :force => true do |t|
    t.string   "name",                                :null => false
    t.boolean  "show_flg",          :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "image_searched_at"
  end

  add_index "artists", ["id", "show_flg"], :name => "idx_id_show_flg_on_artists"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "follows", :id => false, :force => true do |t|
    t.integer "user_id",       :null => false
    t.integer "other_user_id", :null => false
  end

  add_index "follows", ["other_user_id", "user_id"], :name => "idx_other_user_id_user_id_on_follows", :unique => true
  add_index "follows", ["user_id", "other_user_id"], :name => "idx_user_id_other_user_id_on_follows", :unique => true

  create_table "invites", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.string   "message"
    t.integer  "to_provider_id", :null => false
    t.integer  "to_invite_kind"
    t.string   "to_user_key",    :null => false
    t.integer  "to_user_id"
    t.datetime "delivered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["user_id", "to_provider_id", "to_user_key"], :name => "idx_user_id_to_provider_id_to_user_key_on_invites"

  create_table "post_errors", :force => true do |t|
    t.integer  "post_id",       :null => false
    t.integer  "provider_id",   :null => false
    t.integer  "user_id",       :null => false
    t.text     "error_message", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_errors", ["user_id"], :name => "idx_user_id_on_post_errors"

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.text     "content",                             :null => false
    t.integer  "posts_likes_count", :default => 0,    :null => false
    t.boolean  "show_flg",          :default => true, :null => false
    t.datetime "synced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["user_id", "show_flg"], :name => "idx_user_id_show_flg_on_posts"

  create_table "posts_artist_images", :force => true do |t|
    t.integer  "post_id",         :null => false
    t.integer  "artist_image_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_artist_images", ["artist_image_id"], :name => "idx_artist_image_id_on_posts_artist_images"
  add_index "posts_artist_images", ["post_id"], :name => "idx_post_id_on_posts_artist_images"

  create_table "posts_artist_items", :force => true do |t|
    t.integer  "post_id",        :null => false
    t.integer  "artist_item_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_artist_items", ["artist_item_id"], :name => "idx_artist_item_id_on_posts_artist_items"
  add_index "posts_artist_items", ["post_id"], :name => "idx_post_id_on_posts_artist_items"

  create_table "posts_artist_tracks", :force => true do |t|
    t.integer  "post_id",         :null => false
    t.integer  "artist_track_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_artist_tracks", ["artist_track_id"], :name => "idx_artist_track_id_on_posts_artist_tracks"
  add_index "posts_artist_tracks", ["post_id"], :name => "idx_post_id_on_posts_artist_tracks"

  create_table "posts_artists", :force => true do |t|
    t.integer  "post_id",    :null => false
    t.integer  "artist_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_artists", ["artist_id"], :name => "idx_artist_id_on_posts_artists"
  add_index "posts_artists", ["post_id"], :name => "idx_post_id_on_posts_artists"

  create_table "posts_comments", :force => true do |t|
    t.integer  "post_id",                                   :null => false
    t.integer  "user_id"
    t.integer  "provider_id"
    t.string   "user_key"
    t.string   "post_key"
    t.text     "content",                                   :null => false
    t.integer  "posts_comments_likes_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_comments", ["post_id"], :name => "idx_post_id_on_posts_comments"
  add_index "posts_comments", ["user_id"], :name => "idx_user_id_on_posts_comments"

  create_table "posts_comments_likes", :force => true do |t|
    t.integer  "posts_comment_id", :null => false
    t.integer  "user_id"
    t.integer  "provider_id"
    t.string   "user_key"
    t.string   "post_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_comments_likes", ["posts_comment_id"], :name => "idx_posts_comment_id_on_posts_comments_likes"
  add_index "posts_comments_likes", ["provider_id", "posts_comment_id"], :name => "idx_provider_id_posts_comment_id_posts_comments_likes"

  create_table "posts_likes", :force => true do |t|
    t.integer  "post_id",     :null => false
    t.integer  "user_id"
    t.integer  "provider_id"
    t.string   "user_key"
    t.string   "post_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_likes", ["post_id"], :name => "idx_post_id_on_posts_likes"
  add_index "posts_likes", ["provider_id", "post_id"], :name => "idx_provider_id_post_id_on_posts_likes"

  create_table "posts_providers", :force => true do |t|
    t.integer  "provider_id", :null => false
    t.integer  "post_id",     :null => false
    t.string   "post_key",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_providers", ["post_id"], :name => "idx_post_id_on_posts_providers"
  add_index "posts_providers", ["provider_id", "post_id"], :name => "idx_provider_id_post_id_on_posts_providers"

  create_table "posts_user_actions", :force => true do |t|
    t.integer  "post_id",           :null => false
    t.integer  "user_action_id",    :null => false
    t.string   "target_attributes", :null => false
    t.string   "target_name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts_user_actions", ["post_id"], :name => "idx_post_id_on_posts_user_actions", :unique => true

  create_table "provider_profiles", :force => true do |t|
    t.integer  "provider_id", :null => false
    t.string   "user_key",    :null => false
    t.string   "name",        :null => false
    t.string   "pic_square",  :null => false
    t.string   "url",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provider_profiles", ["provider_id", "user_key"], :name => "idx_provider_id_user_key_on_provider_profiles", :unique => true

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "providers", ["name"], :name => "idx_name_on_providers", :unique => true

  create_table "providers_users", :force => true do |t|
    t.integer  "provider_id",   :null => false
    t.integer  "user_id",       :null => false
    t.string   "user_key",      :null => false
    t.string   "access_token",  :null => false
    t.string   "refresh_token"
    t.string   "secret"
    t.string   "name",          :null => false
    t.string   "email",         :null => false
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "providers_users", ["provider_id", "user_key"], :name => "idx_provider_id_user_key_on_providers_users", :unique => true
  add_index "providers_users", ["user_id"], :name => "idx_user_id_on_providers_users"

  create_table "search_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "keyword"
    t.string   "kind"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_logs", ["kind", "target_id"], :name => "idx_kind_target_id_on_search_logs"
  add_index "search_logs", ["user_id"], :name => "idx_user_id_on_search_logs"

  create_table "user_actions", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "target",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_actions", ["name", "target"], :name => "idx_name_target_on_user_actions", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                  :default => "", :null => false
    t.string   "image",                                 :default => "", :null => false
    t.integer  "default_provider_id",                   :default => 0,  :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_artist_items", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "artist_item_id",                :null => false
    t.integer  "priority",       :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_artist_items", ["artist_item_id"], :name => "idx_artist_item_id_on_users_artist_items"
  add_index "users_artist_items", ["user_id", "artist_item_id"], :name => "idx_user_id_artist_item_id_on_users_artist_items", :unique => true
  add_index "users_artist_items", ["user_id", "priority"], :name => "idx_user_id_priority_on_users_artist_items"

  create_table "users_artist_tracks", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "artist_track_id",                :null => false
    t.integer  "priority",        :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_artist_tracks", ["artist_track_id"], :name => "idx_artist_track_id_on_users_artist_tracks"
  add_index "users_artist_tracks", ["user_id", "artist_track_id"], :name => "idx_user_id_artist_track_id_on_users_artist_tracks", :unique => true
  add_index "users_artist_tracks", ["user_id", "priority"], :name => "idx_user_id_priority_on_users_artist_tracks"

  create_table "users_artists", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.integer  "artist_id",                 :null => false
    t.integer  "priority",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_artists", ["artist_id"], :name => "idx_artist_id_on_users_artists"
  add_index "users_artists", ["user_id", "artist_id"], :name => "idx_user_id_artist_id_on_users_artists", :unique => true
  add_index "users_artists", ["user_id", "priority"], :name => "idx_user_id_priority_on_users_artists"

end
