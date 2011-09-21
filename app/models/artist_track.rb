class ArtistTrack < ActiveRecord::Base
  belongs_to :artist
  belogns_to :artist_item
end
