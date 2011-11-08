require 'nkf'
class ArtistItem < ActiveRecord::Base
  belongs_to :artist
  has_many :artist_tracks
  has_many :users_artist_items_tags
  def self.find_items artist_id, page, keyword = ''
    artist = Artist.find artist_id
    search_artist = artist.name
    artist_alias_names = artist.artist_aliases.map{|artist_aliase|artist_aliase.name}
    artist_name = artist.name
    if artist_alias_names.present?
      artist_name += "|" + artist_alias_names.join('|')
    end
    artist_name = "(#{artist_name})"
    
    amazon_params = {
      :search_index => "Music", :response_group => 'ItemAttributes,Images',
      :browse_node => 562032, :item_page => page,
      :response_group => 'Large',
      :sort => 'salesrank',
      :Artist => search_artist
    }
    items_cache_key = 'artist_item_find_items_' + Digest::SHA1.hexdigest(keyword + amazon_params.to_yaml)
    total_cache_key = 'artist_item_find_items_total_' + Digest::SHA1.hexdigest(keyword + amazon_params.to_yaml)
    if Rails.cache.exist?(items_cache_key) && Rails.cache.exist?(total_cache_key)
      items = Rails.cache.read(items_cache_key).dup
      total = Rails.cache.read(total_cache_key)
    else
      result_set = Amazon::Ecs.item_search(keyword, amazon_params)
      items = []
      result_set.items.each do |item|
        item_artist = item.get('ItemAttributes/Artist')
        item_artist = item_artist.present? ? item_artist.encode("UTF-8") : ''
        item_artist = NKF::nkf('-Z1 -Ww', CGI::unescapeHTML(item_artist))
        #next unless item_artist.downcase =~ Regexp.new(artist_name.downcase)
        items << self.format_amazon_item(artist_id, item)
      end
      total = result_set.total_results
      res = Rails.cache.write items_cache_key, items
      res = Rails.cache.write total_cache_key, total
    end
    items.instance_eval <<-EVAL
      def current_page
        #{page || 1}
      end
      def num_pages
        #{total}
      end
      def limit_value
        10
      end
    EVAL
    
    items.map! do |item|
      self.convert_hash_to_arctive_record item
    end
    items
  end
  
  def self.find_or_create artist_id, asin
    artist_item = self.find_by_artist_id_and_asin artist_id, asin
    if artist_item.nil?
      artist_item = self.find_item_from_amazon artist_id, asin
      artist_item.save
    end
    artist_item
  end
  
  protected
  def self.find_item_from_amazon artist_id, asin
    Rails.cache.fetch("artist_item_#{asin}", :expires_in => 24.minutes) do
      item = Amazon::Ecs.item_lookup(asin, {:response_group => 'ItemAttributes,Images',:response_group => 'Large',}).items[0]
      item = self.format_amazon_item artist_id, item
      artist_item = self.convert_hash_to_arctive_record item
    end
  end
  
  def self.format_amazon_item artist_id, item
    tracks = []
    if item.get_elements('Tracks/Disc').instance_of? Array
      item.get_elements('Tracks/Disc').each do |discs|
        discs.get_elements('Track').each do |track|
          title = track.get().present? ? track.get() : ''
          tracks << {
            :artist_id => artist_id,
            :asin => item.get('ASIN'),
            :disc => discs.attributes['Number'].to_s.to_i,
            :track => track.attributes['Number'].to_s.to_i,
            :title => CGI::unescapeHTML(title.encode("UTF-8")),
          }
        end
      end
    end
    title = item.get('ItemAttributes/Title').present? ? item.get('ItemAttributes/Title') : ''
    small_image = item.get_hash('SmallImage')
    small_image_url = small_image.present? ? small_image['URL'] : '/images/musick.png'
    medium_image = item.get_hash('MediumImage')
    medium_image_url = medium_image.present? ? medium_image['URL'] : '/images/musick.png'
    large_image = item.get_hash('LargeImage')
    large_image_url = large_image.present? ? large_image['URL'] : '/images/musick.png'
    label = item.get('ItemAttributes/Label').present? ? item.get('ItemAttributes/Label') : ''
    {
      :artist_id => artist_id,
      :asin => item.get('ASIN'),
      :ean => item.get('ItemAttributes/EAN'),
      :title => CGI::unescapeHTML(title.encode("UTF-8")),
      :detail_page_url => item.get('DetailPageURL'),
      :small_image_url => small_image_url,
      :medium_image_url => medium_image_url,
      :large_image_url => large_image_url,
      :label => CGI::unescapeHTML(label.encode("UTF-8")),
      :product_group => item.get('ItemAttributes/ProductGroup'),
      :format => item.get('ItemAttributes/Format'),
      :release_date => item.get('ItemAttributes/ReleaseDate'),
      :tracks => tracks,
    }
  end
  
  def self.convert_hash_to_arctive_record item
    artist_item = self.new(
      :artist_id => item[:artist_id],
      :asin => item[:asin],
      :ean => item[:ean],
      :title => item[:title],
      :detail_page_url => item[:detail_page_url],
      :small_image_url => item[:small_image_url],
      :medium_image_url => item[:medium_image_url],
      :large_image_url => item[:large_image_url],
      :label => item[:label],
      :product_group => item[:product_group],
      :format => item[:format],
      :release_date => item[:release_date],
    )
    artist_tracks = []
    item[:tracks].each do |track|
      artist_tracks << ArtistTrack.new(track)
    end
    artist_item.artist_tracks = artist_tracks
    artist_item
  end
end
