module SocialSync
  # SocialSync library sync with Twitter account.
  class Twitter
    # fetch friends uid array
    def self.friends token, params = {}
      self.configure_twitter token, params[:providers_user].secret
      user_keys = ::Twitter.friend_ids(params[:providers_user].name).ids
      user_keys.map{|user_key|user_key.to_s}
    end
    
    # fetch post
    def self.post token, params
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
  end
end