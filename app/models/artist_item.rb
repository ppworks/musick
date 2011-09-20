class ArtistItem < ActiveRecord::Base
  def self.find_items artist_id, page, keyword = ''
    artist = Artist.find artist_id
    artist_alias_names = artist.artist_aliases.map{|artist_aliase|artist_aliase.name}
    artist_name = artist.name
    if artist_alias_names.present?
      artist_name += "|" + artist_alias_names.join('|')
    end
    
    amazon_params = {
      :search_index => "Music", :response_group => 'ItemAttributes,Images',
      :browse_node => 562032, :item_page => page,
      :response_group => 'Large',
      :sort => 'salesrank',
      :Artist => artist_name,
    }
    result_set = Amazon::Ecs.item_search(keyword, amazon_params)
    items = []
    result_set.items.each do |item|
      items << self.format_amazon_item(artist_id, item)
    end
    items.instance_eval <<-EVAL
      def current_page
        #{page || 1}
      end
      def num_pages
        #{result_set.total_results}
      end
      def limit_value
        10
      end
    EVAL
    items
  end
  
  protected
  def self.format_amazon_item artist_id, item
    tracks = []
    if item.get_elements('Tracks/Disc').instance_of? Array
      item.get_elements('Tracks/Disc').each do |discs|
        discs.get_elements('Track').each do |track|
          title = track.get().present? ? track.get() : ''
          tracks << {
            :artist_id => artist_id.to_i,
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
      :artist_id => artist_id.to_i,
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
end
