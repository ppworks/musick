class LastfmWrapper::Base
  @api = Lastfm.new(ENV['LASTFM_KEY'] || 'b25b959554ed76058ac220b7b2e0a026', ENV['LASTFM_SECRET'])
  
  def self.api
    @api
  end
end
