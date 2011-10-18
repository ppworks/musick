class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :users_artists_tags
  has_many :users_artist_items_tags
  has_many :users_artist_tracks_tags
end
