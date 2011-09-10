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
  scope :show, where(:show_flg => TRUE)
  
  def self.create_by_lastfm artist_results
    if artist_results.instance_of? Hash
      artist_results = [artist_results]
    end
    created_artists = []
    
    artist_result_urls = artist_results.map{|artist_result|artist_result[:url]}
    duplicated_artists = ArtistLastfm.select(:url).find_all_by_url artist_result_urls
    duplicated_artists_urls = duplicated_artists.map{|duplicated_artist|duplicated_artist.url}
    artist_results.reject!{|artist_result|duplicated_artists_urls.include? artist_result[:url]}

    artist_results.each do|artist_result|
      created_artist = self.create_by_artist_hash(artist_result)
      created_artists << created_artist if created_artist.present?
    end
    return created_artists
  end
  
  private
  def self.create_by_artist_hash artist_result
    artist_info = LastfmWrapper::Artist.info artist_result[:name]
    artist_images = []
    res = LastfmWrapper::Base.api.artist.get_images :artist => artist_result[:name], :autocorrect => 1, :limit => 24
    logger.info "res.length:#{res.length}"
    if res.present? && res.length > 0
      url = nil
      res.each do |r|
        next if r['sizes'].nil? || r['sizes']['size'].nil?
        artist_image = ArtistImage.new()
        r['sizes']['size'].each do |size|
          artist_image.send("#{size['name']}=", size['content'])
        end
        artist_images << artist_image
      end
      artist = Artist.new(:name => artist_result[:name])
      artist.artist_images << artist_images
      artist.artist_lastfm = ArtistLastfm.new({
        :mbid => artist_info[:mbid],
        :url => artist_info[:url],
        :summary => artist_info[:summary].gsub(/<.*?>/, ''),
        :content => artist_info[:content].gsub(/<.*?>/, ''),
        :main_image => artist_info[:main_image]
      })
      artist.save!
      artist
    else
      nil
    end
  end
end
