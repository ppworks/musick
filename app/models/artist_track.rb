class ArtistTrack < ActiveRecord::Base
  belongs_to :artist
  belongs_to :artist_item
end
