class Artist < ActiveRecord::Base
  has_many :artist_aliases
  has_many :artist_images
  has_one :artist_lastfm
  default_scope includes(:artist_aliases)
  default_scope includes(:artist_images)
  scope :search_name, lambda{|keyword| 
    where("artists.name LIKE :keyword OR artist_aliases.name LIKE :keyword",
        :keyword => "%#{keyword}%")
  }
  
  def self.fetch_lastfm keyword
    res = LastfmWrapper::Base.api.artist.get_info :artist => keyword, :autocorrect => 1, :limit => 1
    
    artist_name = res['name']
    mbid == res['mbid']
    if mbid = "--- {}\n"
      mbid = ''
    end
    artist_url = res['url']
    artist = Artist.search_name(artist_name).first
    if artist.present?
      return artist
    end
    
    artist = Artist.new(:name => artist_name)
    artist_images = []
    res = LastfmWrapper::Base.api.artist.get_images :artist => artist_name, :autocorrect => 1, :limit => 24
    if res.present?
      url = nil
      res.each do |r|
        next if r['sizes'].nil? || r['sizes']['size'].nil?
        r['sizes']['size'].each do |size|
          if size['name'] == 'largesquare'
            url = size['content']
            begin
              artist_images << ArtistImage.new(:url => url)
            rescue => e
              pp e.message
            end
          end
        end
      end
    end
    artist.artist_images << artist_images
    artist.artist_lastfm = ArtistLastfm.new(:mbid => mbid, :url => artist_url)
    artist.save!
    artist
  end
end
