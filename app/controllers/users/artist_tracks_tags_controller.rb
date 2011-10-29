class Users::ArtistTracksTagsController < ApplicationController
  def create
    @artist_track = ArtistTrack.find_or_create params[:artist_id], params[:item_asin], params[:disc], params[:track]
    @tag = Tag.find params[:tag_id]
    current_user.users_artist_tracks_tags << UsersArtistTracksTag.new(:artist_track_id => @artist_track.id, :tag_id => @tag.id)
  end
  
  def destroy
    @artist_track = ArtistTrack.find_or_create params[:artist_id], params[:item_asin], params[:disc], params[:track]
    @tag = Tag.find params[:tag_id]
    current_user.users_artist_tracks_tags.where(:artist_track_id => @artist_track.id, :tag_id => params[:tag_id]).delete_all
  end
end
