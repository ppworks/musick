module ArtistsHelper
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
      if current_user.artist_items.find_by_asin asin
        link_to t('musick.users_artist_item.destroy'), users_destroy_artist_item_path(artist_id, asin), :class => 'button', :method => :delete, :remote => true
      else
        link_to t('musick.users_artist_item.create'), users_create_artist_item_path(artist_id, asin), :class => 'button', :method => :post, :remote => true
      end
    else
      link_to t('musick.users_artist_item.create'), login_path, :class => 'button popup'
    end
  end
  
  def link_to_artist_item label, artist_item
    attributes = {
      :class => :popup_action,
      'data-action' => 'create_or_destroy',
      'data-target-id' => artist_item.id,
      'data-target-object' => 'artist_item',
      'data-target-name' => artist_item.title
    }
    link_to label, artist_item_path(artist_item.artist_id, artist_item.asin), attributes
  end
  
  def list_artist_tracks artist_tracks
    discs = {}
    artist_tracks.each do |artist_track|
      discs["disc#{artist_track.disc.to_s}"] ||= []
      discs["disc#{artist_track.disc.to_s}"] << artist_track
    end
    discs.each do |disc, tracks|
      if discs.size > 1
        concat content_tag :h2, disc
      end
      concat content_tag(:ul, nil, :class => disc) {
        tracks.each do |track|
          concat content_tag(:li) {
            attributes = {
              :class => :popup_action,
              'data-action' => 'create_or_destroy',
              'data-target-id' => track.id,
              'data-target-object' => 'artist_track',
              'data-target-name' => track.title
            }
            concat content_tag(:a, nil, attributes) {
              concat content_tag :small, "#{track.track}. "
              concat track.title
            }
          }
        end
      }
    end
  end
end
