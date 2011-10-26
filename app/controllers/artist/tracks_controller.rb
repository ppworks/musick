class Artist::TracksController < ApplicationController
  def show
    @artist_item = ArtistItem.find_or_create params[:artist_id], params[:item_asin]
    @artist_track = ArtistTrack.find_or_create params[:artist_id], params[:item_asin], params[:disc], params[:track]
    @users_artist_tracks = UsersArtistTrack.includes(:user).where(:artist_track_id => @artist_track.id).order('updated_at DESC').limit(16).all
    @users_artist_tracks_tags = UsersArtistTracksTag.includes(:tag).includes(:user).where(:artist_track_id => @artist_track.id).order('updated_at DESC').limit(16).all
    render :layout => !request.xhr?
  end
end
