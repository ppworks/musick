class Users::ArtistsController < ApplicationController
  before_filter :authenticate_user!
  def create
    @artist = Artist.find(params[:id])
    current_user.artists << @artist
  end

  def destroy
    @artist = Artist.find(params[:id])
    current_user.artists.delete @artist
  end
  
  def index
    user = User.find params[:user_id]
    @artists = user.artists.order("users_artists.priority, users_artists.id DESC").page(params[:page])
    render :layout => !request.xhr?
  end
end
