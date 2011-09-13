module SocialSync
  # SocialSync library sync with Mixi account.
  class Mixi
    # fetch friends uid array
    def self.friends token, params = {}
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        response = JSON.parse token_obj.get('/2/people/@me/@friends?count=1000')
        response = response["entry"]
      end
    end
    
    # fetch post
    def self.post! token, params
      response = self.fetch_mixi params[:providers_user] do |token_obj|
        response = token_obj.post('/2/voice/statuses', {:status => params[:message]})
      end
    end
    
    protected
    def self.fetch_mixi providers_user
      client = OAuth2::Client.new(
        MixiConfig.app_id,
        MixiConfig.app_secret,
        :site => 'http://api.mixi-platform.com',
        :authorize_url => 'https://mixi.jp/connect_authorize.pl',
        :access_token_url => 'https://secure.mixi-platform.com/2/token'
      )
      retry_count = 0
      begin
        token = OAuth2::AccessToken.new(client, providers_user.access_token)
        res = yield token
      rescue => e
        token = client.web_server.refresh_access_token(providers_user.refresh_token, :grant_type => "refresh_token")
        
        providers_user.access_token = token.token
        providers_user.refresh_token = token.refresh_token
        providers_user.save!
        
        retry_count += 1
        retry if retry_count == 0
        raise e
      end
    end
  end
end