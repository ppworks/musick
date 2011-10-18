class UsersArtistTracksTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :artist_track
  belongs_to :tag
end
