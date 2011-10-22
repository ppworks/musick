module TagsHelper
  def link_to_tags target_object, target_attributes, tags
    link_to_tag_helper = "link_to_users_#{target_object}_tags_create_or_destroy"
    
    content_tag(:ul) {
      tags.each do |tag|
        concat content_tag (:li) {
          params = *target_attributes + [tag.id, tag.send("name_#{css_locale}")]
          concat send(link_to_tag_helper, *params) if respond_to? link_to_tag_helper
        }
      end
    }
  end
  
  def link_to_users_artists_tags_create_or_destroy artist_id, tag_id, tag_name
    if user_signed_in?
      if current_user.users_artists_tags.where(:artist_id => artist_id).where(:tag_id => tag_id).exists?
        link_to t('musick.users_artists_tag.destroy', :tag => tag_name), users_destroy_artists_tag_path(artist_id, tag_id), :class => 'button destroy', :method => :delete, :remote => true
      else
        link_to t('musick.users_artists_tag.create', :tag => tag_name), users_create_artists_tag_path(artist_id, tag_id), :class => 'button create', :method => :post, :remote => true
      end
    else
      link_to t('musick.users_artists_tag.create', :tag => tag_name), login_path, :class => 'button popup'
    end
  end
  
  def link_to_users_artist_items_tags_create_or_destroy artist_id, item_asin, tag_id, tag_name
    if user_signed_in?
      artist_item = ArtistItem.find_by_artist_id_and_asin artist_id, item_asin
      if artist_item.present? && current_user.users_artist_items_tags.where(:artist_item_id => artist_item.id).where(:tag_id => tag_id).exists?
        link_to t('musick.users_artist_items_tag.destroy', :tag => tag_name), users_destroy_artist_items_tag_path(artist_id, item_asin, tag_id), :class => 'button destroy', :method => :delete, :remote => true
      else
        link_to t('musick.users_artist_items_tag.create', :tag => tag_name), users_create_artist_items_tag_path(artist_id, item_asin, tag_id), :class => 'button create', :method => :post, :remote => true
      end
    else
      link_to t('musick.users_artist_items_tag.create', :tag => tag_name), login_path, :class => 'button popup'
    end
  end
  
  def link_to_users_artist_tracks_tags_create_or_destroy artist_id, item_asin, disc, track, tag_id, tag_name
    if user_signed_in?
      artist_track = ArtistTrack.find_by_artist_id_and_asin_and_disc_and_track artist_id, item_asin, disc, track
      if artist_track.present? && current_user.users_artist_tracks_tags.where(:artist_track_id => artist_track.id).where(:tag_id => tag_id).exists?
        link_to t('musick.users_artist_tracks_tag.destroy', :tag => tag_name), users_destroy_artist_tracks_tag_path(artist_id, item_asin, disc, track, tag_id), :class => 'button destroy', :method => :delete, :remote => true
      else
        link_to t('musick.users_artist_tracks_tag.create', :tag => tag_name), users_create_artist_tracks_tag_path(artist_id, item_asin, disc, track, tag_id), :class => 'button create', :method => :post, :remote => true
      end
    else
      link_to t('musick.users_artist_tracks_tag.create', :tag => tag_name), login_path, :class => 'button popup'
    end
  end
end