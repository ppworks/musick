module ArtistsHelper
  
  def link_to_detail_page label, target_object, target_attributes
    if target_object == "artist_items"
      link_to label, artist_item_path(*target_attributes)
    elsif target_object == "artist_tracks"
      link_to label, artist_track_path(*target_attributes)
    end
  end
  
  def link_to_clip target_object, target_attributes
    link_to_clip_helper = "link_to_users_#{target_object}_create_or_destroy"
    send(link_to_clip_helper, *target_attributes) if respond_to? link_to_clip_helper
  end
  
  def link_to_users_artists_create_or_destroy artist_id
    if user_signed_in?
      if current_user.artists.exists? artist_id
        link_to t('musick.users_artist.destroy'), users_destroy_artist_path(artist_id), :class => 'button', :method => :delete, :remote => true
      else
        link_to t('musick.users_artist.create'), users_create_artist_path(artist_id), :class => 'button', :method => :post, :remote => true
      end
    else
      link_to t('musick.users_artist.create'), login_path, :class => 'button popup'
    end
  end
  
  def link_to_users_artist_items_create_or_destroy artist_id, asin
    if user_signed_in?
      if current_user.artist_items.find_by_artist_id_and_asin artist_id, asin
        link_to t('musick.users_artist_item.destroy'), users_destroy_artist_item_path(artist_id, asin), :class => 'button', :method => :delete, :remote => true
      else
        link_to t('musick.users_artist_item.create'), users_create_artist_item_path(artist_id, asin), :class => 'button', :method => :post, :remote => true
      end
    else
      link_to t('musick.users_artist_item.create'), login_path, :class => 'button popup'
    end
  end
  
  def link_to_users_artist_tracks_create_or_destroy artist_id, asin, disc, track
    if user_signed_in?
      if current_user.artist_tracks.find_by_artist_id_and_asin_and_disc_and_track artist_id, asin, disc, track
        link_to t('musick.users_artist_track.destroy'), users_destroy_artist_track_path(artist_id, asin, disc, track), :class => 'button', :method => :delete, :remote => true
      else
        link_to t('musick.users_artist_track.create'), users_create_artist_track_path(artist_id, asin, disc, track), :class => 'button', :method => :post, :remote => true
      end
    else
      link_to t('musick.users_artist_track.create'), login_path, :class => 'button popup'
    end
  end
  
  def link_to_artist label, artist
    if user_signed_in?
      attributes = {
        :class => [:popup_action, :with_tooltip],
        'data-target-attributes' => [artist.id].to_yaml,
        'data-target-object' => 'artist',
        'data-target-name' => artist.name,
        'data-target-image' => artist.artist_lastfm.thumbnail_image,
        'data-tooltip' => t('musick.post.tooltip', :target => artist.name),
      }
      link_to label, artist_path(artist.id), attributes
    else
      link_to label, login_path, :class => 'popup'
    end
  end
  
  def link_to_artist_image label, artist_image
    if user_signed_in?
      attributes = {
        :class => [:popup_action, :with_tooltip],
        'data-target-attributes' => [artist_image.id].to_yaml,
        'data-target-object' => 'artist_image',
        'data-target-name' => artist_image.artist.name,
        'data-target-image' => artist_image.largesquare,
        'data-tooltip' => t('musick.post.tooltip', :target => artist_image.artist.name),
      }
      link_to label, artist_image_path(artist_image.artist_id, artist_image.id), attributes
    else
      link_to label, login_path, :class => 'popup'
    end
  end
  
  def link_to_artist_item label, artist_item
    if user_signed_in?
      attributes = {
        :class => [:popup_action, :with_tooltip],
        'data-target-attributes' => [artist_item.artist_id, artist_item.asin].to_yaml,
        'data-target-object' => 'artist_item',
        'data-target-name' => artist_item.title,
        'data-target-image' => artist_item.medium_image_url,
        'data-tooltip' => t('musick.post.tooltip', :target => artist_item.title),
      }
      link_to label, artist_item_path(artist_item.artist_id, artist_item.asin), attributes
    else
      link_to label, login_path, :class => 'popup'
    end
  end
  
  def list_artist_tracks artist_tracks, selected_artist_track = nil
    discs = {}
    artist_tracks.each do |artist_track|
      discs["disc#{artist_track.disc.to_s}"] ||= []
      discs["disc#{artist_track.disc.to_s}"] << artist_track
    end
    discs.each do |disc, artist_tracks|
      if discs.size > 1
        concat content_tag :h2, disc
      end
      concat content_tag(:ul, nil, :class => disc) {
        artist_tracks.each do |artist_track|
          selected_class = selected_artist_track.present? && (artist_track.id == selected_artist_track.id) ? 'selected':''
          concat content_tag(:li, :class => selected_class) {
            concat link_to_artist_track artist_track
          }
        end
      }
    end
  end
  
  def link_to_artist_track artist_track
    if user_signed_in?
      attributes = {
        :class => [:popup_action, :with_tooltip],
        'data-target-attributes' => [artist_track.artist_id, artist_track.asin, artist_track.disc, artist_track.track].to_yaml,
        'data-target-object' => 'artist_track',
        'data-target-name' => artist_track.title,
        'data-tooltip' => t('musick.post.tooltip', :target => artist_track.title),
      }
      content_tag(:a, nil, attributes) {
        concat content_tag :small, "#{artist_track.track}. "
        concat artist_track.title
      }
      else
      link_to login_path, :class => 'popup' do
        concat content_tag :small, "#{artist_track.track}. "
        concat artist_track.title
      end
    end
  end
  
  # unofficial solution to fetch image from amazon.
  def url_artist_item_image artist_item, size
    artist_item.large_image_url.sub(/\.([^.]+?)$/, "._SL#{size}." + '\1')
  end
end
