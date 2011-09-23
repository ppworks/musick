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
  
  def list_tracks artist_tracks
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
            concat content_tag :small, "#{track.track}. "
            concat track.title
          }
        end
      }
    end
  end
end
