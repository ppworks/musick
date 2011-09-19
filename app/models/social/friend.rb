class Social::Friend
  def self.fetch opts = {}
    opts.reverse_merge! :current_user => nil, :provider => nil
    current_user = opts[:current_user]
    provider = opts[:provider]
    unless current_user.has_provider?(Provider.send(provider).id)
      return []
    end
    Rails.cache.fetch("social_friend_#{provider}_#{current_user.id}", :expires_in => 12.hours) do
      opts = {}
      friends = SocialSync.friends(current_user, opts.merge({:provider_id => Provider.send(provider)}))
      
      case provider.to_sym
      when :facebook
        opts = {:uid => friends}
        SocialSync.profiles(current_user, opts.merge({:provider_id => Provider.send(provider)}))
      else
        friends
      end
    end
  end
end