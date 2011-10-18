class ArtistTrack < ActiveRecord::Base
  belongs_to :artist
  belongs_to :artist_item
  has_many :users_artist_tracks_tags
  def self.find_or_create artist_id, asin, disc, track
    artist_item = ArtistItem.find_or_create artist_id, asin
    artist_item.artist_tracks.each do |artist_track|
      if disc.to_s == artist_track.disc.to_s && track.to_s == artist_track.track.to_s
        return artist_track
      end
    end
    return nil
  end
end
