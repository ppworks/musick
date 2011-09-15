module SocialSync
  # SocialSync library sync with Twitter account.
  class Twitter
    # fetch friends uid array
    def self.friends token, params = {}
      self.configure_twitter token, params[:providers_user].secret
      friends = ::Twitter.friends(params[:providers_user].name)
      if friends[:users].present?
        friends[:users].map do |user|
          self.format_profile user
        end
      else
        []
      end
    end
    
    # fetch post
    def self.post! token, params
      self.configure_twitter token, params[:providers_user].secret
      res = ::Twitter.update(params[:message])
      
    end
    
    protected
    def self.configure_twitter token, secret
      ::Twitter.configure do |config|
        config.consumer_key = TwitterConfig.app_id
        config.consumer_secret = TwitterConfig.app_secret
        config.oauth_token = token
        config.oauth_token_secret = secret
      end
    end
    
    def self.format_profile user
      {
        :id => user['id'].to_s,
        :name => user['name'],
        :screen_name => user['screen_name'],
        :pic_square => user['profile_image_url'],
        :url => "http://twitter.com/#!/#{user['screen_name']}",
        :provider => :twitter
      }
    end
  end
end