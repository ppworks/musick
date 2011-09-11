module MixiConfig
  def self.app_id
    ENV["MIXI_KEY"]
  end

  def self.app_secret
    ENV["MIXI_SECRET"]
  end
  
  def self.scope
    ENV["MIXI_SCOPE"]||'r_profile r_voice w_voice w_message'
  end
end