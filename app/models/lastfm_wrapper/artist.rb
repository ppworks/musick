class LastfmWrapper::Artist < LastfmWrapper::Base
  SEARCH_LIMIT = 10
  
  def self.info keyword, opts = {}
    opts.merge! :artist => keyword, :autocorrect => 1, :lang => 'jp'
    result = self.api.artist.get_info opts
    if result.blank?
      return nil
    end
    main_image = nil
    result['image'].each do |image|
      main_image = image['content'] if image['size'] == 'mega'
    end
    artist = {
      :name => result['name'],
      :mbid => result['mbid'],
      :main_image => main_image,
      :url => result['url'],
      :summary => result['bio']['summary'].instance_of?(String) ? result['bio']['summary'] : '',
      :content => result['bio']['content'].instance_of?(String) ? result['bio']['content'] : ''
    }
  end
  
  def self.images keyword, opts = {}
    opts.merge! :artist => keyword, :autocorrect => 1, :limit => 24
    result = self.api.artist.get_images opts
    artist_images = []
    if result.present? && result.length > 0
      result.each do |r|
        next if r['sizes'].nil? || r['sizes']['size'].nil?
        artist_image = {}
        r['sizes']['size'].each do |size|
          artist_image["#{size['name']}".to_sym] = size['content']
        end
        artist_images << artist_image
      end
    end
    artist_images
  end
  
  def self.search keyword, opts = {}
    opts.merge! :artist => keyword
    results = self.api.artist.search opts
    if results.blank? || results['artistmatches']['artist'].nil?
      return []
    end
    artists = []
    if results['artistmatches']['artist'].instance_of? Array
      results['artistmatches']['artist'].each do |artist|
        res = self.format_search_result artist
        artists << res if res.present?
      end
    elsif results['artistmatches']['artist'].instance_of? Hash
      res = self.format_search_result results['artistmatches']['artist']
      artists << res if res.present?
    end
    artists
  end
  
  private
  def self.format_search_result artist
    return false if artist['image'].reject{|image|image['content'].nil?}.blank?
    return false if artist['url'].blank?
    mbid = (artist['mbid']=~/[0-9a-zA-Z]/) ? artist['mbid'] : nil
    {
      :name => artist['name'],
      :mbid => mbid,
      :url => artist['url'],
      :streamable => artist['streamable'],
    }
  end
end
