module TwitterConfig
  def self.app_id
    ENV["TW_KEY"]
  end

  def self.app_secret
    ENV["TW_SECRET"]
  end
  
  def self.scope
    ENV["TW_SCOPE"]||'publish_stream,offline_access,email'
  end
end