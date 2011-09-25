module PostHelper
  def like_link post
    posts_likes = {}
    post.posts_likes.where(:user_id => current_user.id).each do |posts_like|
      posts_likes[posts_like.provider_id] = 1
    end
    content_tag(:ul, :class => 'like') do
      Provider.all.each do |provider|
        if posts_likes[provider.id].present?
          concat render 'posts/likes/unlike_link', :post => post, :provider => provider
        else
          concat render 'posts/likes/like_link', :post => post, :provider => provider
        end
      end
    end
  end
  
  def comment_like_link posts_comment
    posts_comments_likes = {}
    posts_comment.posts_comments_likes.where(:user_id => current_user.id).each do |posts_comments_like|
      posts_comments_likes[posts_comments_like.provider_id] = 1
    end
    content_tag(:ul, :class => 'like') do
      Provider.all.each do |provider|
        if provider.id == Provider.mixi.id
          next
        end
        if posts_comments_likes[provider.id].present?
          concat render 'posts/comments_likes/unlike_link', :posts_comment => posts_comment, :provider => provider
        else
          concat render 'posts/comments_likes/like_link', :posts_comment => posts_comment, :provider => provider
        end
      end
    end
  end
  
  # User image tag for PostsComment
  def comment_user_image posts_comment
    if posts_comment.user.present?
      # has added app
      image_tag posts_comment.user.image
    else
      case posts_comment.provider_id
        when Provider.facebook.id
          # TODO: move to config
          image_tag 'http://graph.facebook.com/' + posts_comment.user_key.to_s + '/picture'
        when Provider.mixi.id
          content_tag :span, nil, {:class => :unknown, 'data-field' => 'image', 'data-provider-id' => posts_comment.provider_id, 'data-user-key' => posts_comment.user_key.to_s}
      end
    end
  end
  
  # User name for PostComment
  def comment_user_name posts_comment
    user_name posts_comment.user, posts_comment.provider_id, posts_comment.user_key
  end
  
  # display User name
  def user_name user, provider_id, user_key
    if user.present?
      link_to user.name, users_posts_path(user.id)
    else
      content_tag :span, nil, {:class => :unknown, 'data-field' => 'name', 'data-provider-id' => provider_id, 'data-user-key' => user_key}
    end
  end
  
  def like_people post
    count = post.posts_likes_count
    viewer_liked = false
    user_names = []
    post.posts_likes.each do |posts_likes|
      if posts_likes.user.present? && posts_likes.user.id == current_user.id
        viewer_liked = true
        next
      end
      user_names << user_name(posts_likes.user, posts_likes.provider_id, posts_likes.user_key)
    end
    if viewer_liked
      user_names.unshift t('musick.user.you')
    end
    
    if count == 0
      return ''
    elsif count == 1 
      people_str = t('musick.post.like_count_label.person', :count => count)
    else
      people_str = t('musick.post.like_count_label.people', :count => count)
    end
    content_tag(:li, :style => 'position:relative;display: list-item;') do
      concat content_tag(:div, :class => :like_people) {
        concat content_tag(:a, people_str, :href => '#', :class => :like_users)
        concat content_tag(:ul, :class => :like_users) {
          user_names.each do |name|
            concat content_tag(:li, name, nil, false)
          end
        }
      }
    end
  end
  
  def comments_like_people posts_comment
    count = posts_comment.posts_comments_likes_count
    viewer_liked = false
    user_names = []
    posts_comment.posts_comments_likes.each do |posts_comments_likes|
      if posts_comments_likes.user.present? && posts_comments_likes.user.id == current_user.id
        viewer_liked = true
        next
      end
      user_names << user_name(posts_comments_likes.user, posts_comments_likes.provider_id, posts_comments_likes.user_key)
    end
    if viewer_liked
      user_names.unshift t('musick.user.you')
    end
    
    if count == 0
      return ''
    elsif count == 1 
      people_str = t('musick.post.comment_like_count_label.person', :count => count)
    else
      people_str = t('musick.post.comment_like_count_label.people', :count => count)
    end
    content_tag(:span, :class => :comments_like_people, :style => 'position:relative;') {
      concat content_tag(:a, people_str, :href => '#', :class => :like_users)
      concat content_tag(:ul, :class => :like_users) {
        user_names.each do |name|
          concat content_tag(:li, name, nil, false)
        end
      }
    }
  end
end
