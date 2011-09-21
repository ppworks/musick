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
end
