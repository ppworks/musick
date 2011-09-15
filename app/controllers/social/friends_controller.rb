class Social::FriendsController < ApplicationController
  def index
    opts = {}
    friends = SocialSync.friends(current_user, opts.merge({:provider_id => Provider.send(params[:provider])}))
    
    case params[:provider].to_sym
    when :facebook
      opts = {:uid => friends}
      @profiles = SocialSync.profiles(current_user, opts.merge({:provider_id => Provider.send(params[:provider])}))
    else
      @profiles = friends
    end
  end
  
  
end
