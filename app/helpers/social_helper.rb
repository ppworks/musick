module SocialHelper
  def providers_checkbox
    content_tag :ul, nil, {:class => :providers} {
      if current_user.has_provider? Provider.facebook.id
        concat content_tag :li, check_box_tag(:facebook, 1, 1, :class => :checkbox) +
        content_tag(:label, :for => 'facebook', :class => :checkbox) {
          image_tag '/images/provider_select_facebook.png'
        }
      end
      if current_user.has_provider? Provider.twitter.id
        concat content_tag :li, check_box_tag(:twitter, 1, 1, :class => :checkbox) +
        content_tag(:label, :for => 'twitter', :class => :checkbox) {
          image_tag '/images/provider_select_twitter.png'
        }
      end
      if current_user.has_provider? Provider.mixi.id
        concat content_tag :li, check_box_tag(:mixi, 1, 1, :class => :checkbox) +
        content_tag(:label, :for => 'mixi', :class => :checkbox) {
          image_tag '/images/provider_select_mixi.png'
        }
      end
    }
  end
  
  def providers_raido_button post
    valid_provider_ids = post.posts_providers.map{|posts_provider|posts_provider.provider_id}
    content_tag :ul, nil, {:class => :providers} {
      if current_user.has_provider?(Provider.facebook.id) && valid_provider_ids.include?(Provider.facebook.id)
        concat content_tag :li, radio_button_tag(:provider_id, Provider.facebook.id, current_user.default_provider.id == Provider.facebook.id, :class => :radio, :id => "post_#{post.id}_provider_facebook") +
        content_tag(:label, :for => "post_#{post.id}_provider_facebook", :class => :radio) {
          image_tag '/images/provider_select_facebook.png'
        }
      end
      if current_user.has_provider?(Provider.twitter.id) && valid_provider_ids.include?(Provider.twitter.id)
        concat content_tag :li, radio_button_tag(:provider_id, Provider.twitter.id, current_user.default_provider.id == Provider.twitter.id, :class => :radio, :id => "post_#{post.id}_provider_twitter") +
        content_tag(:label, :for => "post_#{post.id}_provider_twitter", :class => :radio) {
          image_tag '/images/provider_select_twitter.png'
        }
      end
      if current_user.has_provider?(Provider.mixi.id) && valid_provider_ids.include?(Provider.mixi.id)
        concat content_tag :li, radio_button_tag(:provider_id, Provider.mixi.id, current_user.default_provider.id == Provider.mixi.id, :class => :radio, :id => "post_#{post.id}_provider_mixi") +
        content_tag(:label, :for => "post_#{post.id}_provider_mixi", :class => :radio) {
          image_tag '/images/provider_select_mixi.png'
        }
      end
    }
  end

  def providers_tab
    content_tag :nav do
      concat content_tag :ul, nil, {:class => [:tab, :providers]} {
        if current_user.has_provider? Provider.facebook.id
          concat content_tag :li, link_to_unless_current('facebook', social_friends_path(:facebook)), :class => (params[:provider] == 'facebook'?'selected':'')
        end
        if current_user.has_provider? Provider.twitter.id
          concat content_tag :li, link_to_unless_current('twitter', social_friends_path(:twitter)), :class => (params[:provider] == 'twitter'?'selected':'')
        end
        if current_user.has_provider? Provider.mixi.id
          concat content_tag :li, link_to_unless_current('mixi', social_friends_path(:mixi)), :class => (params[:provider] == 'mixi'?'selected':'')
        end
      }
    end
  end
  
end