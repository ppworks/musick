module MixiConfig
  def self.app_id
    if Rails.env.production?
      '9056f842491d26b2d082'
    else
      ENV["MIXI_KEY"]
    end
  end

  def self.app_secret
    if Rails.env.production?
      'b338c0a847d4dccaca8e3ec1f4068f0d66b1ff6a'
    else
      ENV["MIXI_SECRET"]
    end
  end
  
  def self.scope
    ENV["MIXI_SCOPE"]||'r_profile r_voice w_voice w_message'
  end
end