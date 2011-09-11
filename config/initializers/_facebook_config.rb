module FacebookConfig
  def self.app_id
    ENV["FB_APP_ID"]
  end

  def self.app_secret
    ENV["FB_APP_SECRET"]
  end
  
  def self.scope
    ENV["FB_SCOPE"]||'publish_stream,offline_access,email'
  end
end