class Users::ArtistsController < ApplicationController
  before_filter :authenticate_user!
  def create
    current_user.artists << Artist.find(params[:id])
  end

  def destroy
    current_user.artists.delete Artist.find(params[:id])
  end
  
  def index
    user = User.find params[:user_id]
    @artists = user.artists.order("users_artists.priority, users_artists.id DESC").page(params[:page])
    render :layout => !request.xhr?
  end
end
