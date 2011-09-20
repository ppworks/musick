class Artist < ActiveRecord::Base
  has_many :artist_aliases
  has_many :artist_images
  has_one :artist_lastfm
  default_scope includes(:artist_aliases)
  default_scope includes(:artist_images)
  default_scope includes(:artist_lastfm)
  scope :search_name, lambda{|keyword| 
    where("artists.name LIKE :keyword OR artist_aliases.name LIKE :keyword",
        :keyword => "%#{keyword}%")
  }
  scope :show, where(:show_flg => TRUE)
  
  def self.create_by_lastfm keyword
    artist_results = LastfmWrapper::Artist.search keyword, {:limit => LastfmWrapper::Artist::SEARCH_LIMIT}
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
  
  def self.find_and_update_lastfm id
    artist = self.show.find id
    if artist.artist_lastfm.created_at == artist.artist_lastfm.updated_at || artist.artist_lastfm.updated_at < 7.weeks.ago
      artist_info = LastfmWrapper::Artist.info artist.name
      artist.artist_lastfm.attributes = {
        :mbid => artist_info[:mbid],
        :url => artist_info[:url],
        :summary => artist_info[:summary].gsub(/<.*?>/, ''),
        :content => artist_info[:content].gsub(/<.*?>/, ''),
        :main_image => artist_info[:main_image],
        :thumbnail_image => artist_info[:thumbnail_image]
      }
      artist.artist_lastfm.save!
    end
    artist.save!
    artist.reload
    artist
  end
  
  def self.find_images id
    artist = self.show.find id
    artist_image_ids = []
    if artist.image_searched_at.nil? || artist.image_searched_at < 7.weeks.ago
      artist_images = LastfmWrapper::Artist.images artist.name
      return nil if artist_images.blank?
      begin
        artist_images.each do |artist_image|
          new_image = ArtistImage.new(artist_image)
          artist.artist_images << new_image
          artist_image_ids << new_image.id
        end
      rescue ::ActiveRecord::RecordNotUnique => e
      ensure
        artist.image_searched_at = Time.now
        artist.save!
      end
    end
    artist.artist_images.find artist_image_ids
  end
  
  private
  def self.create_by_artist_hash artist_result
    artist = Artist.new(:name => artist_result[:name])
    artist.artist_lastfm = ArtistLastfm.new({
      :mbid => artist_result[:mbid],
      :url => artist_result[:url],
      :summary => '',
      :content => '',
      :main_image => artist_result[:mega],
      :thumbnail_image => artist_result[:large].sub(/\/126\//, '/126s/')
    })
    artist.save!
    self.delay.find_and_update_lastfm(artist.id)
    self.delay.find_images(artist.id)
    artist
  end
end
