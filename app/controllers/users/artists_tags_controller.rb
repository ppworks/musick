class Users::ArtistsTagsController < ApplicationController
  def create
    artist = Artist.find params[:artist_id]
    @tag = Tag.find params[:tag_id]
    current_user.users_artists_tags << UsersArtistsTag.new(:artist_id => artist.id, :tag_id => @tag.id)
  end
  
  def destroy
    @tag = Tag.find params[:tag_id]
    current_user.users_artists_tags.where(:artist_id => params[:artist_id], :tag_id => params[:tag_id]).delete_all
  end
end
