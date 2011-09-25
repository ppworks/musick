class PostsLike < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, :counter_cache => true
  
  # post to remote 
  def like_remote! provider_id = nil
    if provider_id.blank?
      provider_id = self.user.default_provider.id
    end
    return false unless (self.valid?)
    posts_provider = self.post.posts_providers.where(:provider_id => provider_id).first
    return false if posts_provider.blank?
    
    post_key = posts_provider.post_key
    res = SocialSync.like! self.user, self.attributes.merge(:post_key => post_key, :provider_id => provider_id)
    if res === true
      self.user_key = self.user.providers_users.where(:provider_id => provider_id).first.user_key
      self.provider_id = provider_id
      self.save!
    end
  end
  
  def unlike_remote! provider_id = nil
    if provider_id.blank?
      provider_id = self.user.default_provider.id
    end
    return false unless (self.valid?)
    posts_provider = self.post.posts_providers.where(:provider_id => provider_id).first
    return false if posts_provider.blank?
    
    post_key = posts_provider.post_key
    res = SocialSync.unlike! self.user, self.attributes.merge(:post_key => post_key, :provider_id => provider_id)
    if res === true
      self.destroy
    end
  end
end
