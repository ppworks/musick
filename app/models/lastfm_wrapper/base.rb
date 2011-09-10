class LastfmWrapper::Base
  def self.api
    @api = Lastfm.new(ENV['LASTFM_KEY'] || 'b25b959554ed76058ac220b7b2e0a026', ENV['LASTFM_SECRET'])
  end
end
