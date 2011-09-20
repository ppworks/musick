module ArtistsHelper
  def link_to_artist_follow_or_unfollow artist_id
    if user_signed_in?
      if current_user.follow_artists.exists? artist_id
        link_to t('musick.nav.artist.unfollow'), user_unfollow_artist_path(artist_id), :class => 'button', :method => :delete, :remote => true
      else
        link_to t('musick.nav.artist.follow'), user_follow_artist_path(artist_id), :class => 'button', :method => :post, :remote => true
      end
    else
      link_to t('musick.nav.artist.follow'), login_path, :class => 'button popup'
    end
  end
end
