class User::ArtistsController < ApplicationController
  before_filter :authenticate_user!
  def follow
    current_user.follow_artists << Artist.find(params[:id])
  end

  def unfollow
    current_user.follow_artists.delete Artist.find(params[:id])
  end
  
  def follows
    user = User.find params[:user_id]
    @artists = user.follow_artists.order("user_follow_artists.priority, user_follow_artists.id DESC").page(params[:page])
    render :layout => !request.xhr?
  end
end
