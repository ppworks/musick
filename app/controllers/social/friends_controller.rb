class Social::FriendsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @profiles = Rails.cache.fetch("social_friends_#{params[:provider]}_#{current_user.id}", :expires_in => 12.hours) do
      opts = {}
      friends = SocialSync.friends(current_user, opts.merge({:provider_id => Provider.send(params[:provider])}))
      
      case params[:provider].to_sym
      when :facebook
        opts = {:uid => friends}
        SocialSync.profiles(current_user, opts.merge({:provider_id => Provider.send(params[:provider])}))
      else
        friends
      end
    end
    render :layout => !request.xhr?
  end
  
  
end
