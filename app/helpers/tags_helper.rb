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
end