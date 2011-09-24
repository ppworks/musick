class UsersArtistTrack < ActiveRecord::Base
  belongs_to :user
  belongs_to :artist_track
end
