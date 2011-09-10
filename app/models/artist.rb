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
    artist_images = LastfmWrapper::Artist.images artist_result[:name]
    return nil if artist_images.blank?

    artist = Artist.new(:name => artist_result[:name])
    artist_images.each do |artist_image|
      artist.artist_images << ArtistImage.new(artist_image)
    end
    artist.artist_lastfm = ArtistLastfm.new({
      :mbid => artist_info[:mbid],
      :url => artist_info[:url],
      :summary => artist_info[:summary].gsub(/<.*?>/, ''),
      :content => artist_info[:content].gsub(/<.*?>/, ''),
      :main_image => artist_info[:main_image]
    })
    artist.save!
    artist
  end
end
