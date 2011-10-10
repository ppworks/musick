module TwitterConfig
  def self.app_id
    #ENV["TW_KEY"]
    'cU3LgLKXEJUIbNmC9p7xvQ'
  end

  def self.app_secret
    #ENV["TW_SECRET"]
    'AnPPhu4xmKhLKbIpuwLRcpsYWFUaL49o3DOK1I'
  end
  
  def self.scope
    ENV["TW_SCOPE"]||'publish_stream,offline_access,email'
  end
end