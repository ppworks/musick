class Users::ArtistTracksController < ApplicationController
  def create
    artist_track = ArtistTrack.find_or_create params[:artist_id], params[:item_asin], params[:disc], params[:track]
    if artist_track.nil?
      raise Exception
    end
    current_user.artist_tracks << artist_track
  end
  
  def destroy
    artist_track = ArtistTrack.find_or_create params[:artist_id], params[:item_asin], params[:disc], params[:track]
    if artist_track.nil?
      raise Exception
    end
    current_user.artist_tracks.delete artist_track
  end
  
  def index
    user = User.find params[:user_id]
    user.artist_tracks.paginates_per(10)
    @artist_tracks = user.artist_tracks.includes(:artist_item).order("users_artist_tracks.priority, users_artist_tracks.id DESC").page(params[:page])
    render :layout => !request.xhr?
  end
end
