class PostsComment < ActiveRecord::Base
  validates :content, :presence => true, :length => {:maximum => 120}
  
  belongs_to :post
  belongs_to :user
  belongs_to :provider
  has_many :posts_comments_likes, :include => :user
  
  # post to remote 
  def remote! provider_id = nil
    return false unless (self.valid?)
    if provider_id.nil?
      return false
    end
    posts_provider = self.post.posts_providers.where(:provider_id => provider_id).first
    provider_id = posts_provider.provider_id
    return false if posts_provider.blank?
    
    post_key = posts_provider.post_key
    begin
      res = SocialSync.comment! self.user, self.attributes.merge(:post_key => post_key, :provider_id => provider_id, :message => self.content)
      self.provider_id = provider_id
      self.user_key = self.user.providers_users.where(:provider_id => provider_id).first.user_key
      self.post_key = res.identifier
      self.save!
    rescue SocialSync::FacebookException => e
      if e.message =~ /not found/
        logger.info e
        self.save!
      else
        raise e
      end
    end
  end
end
