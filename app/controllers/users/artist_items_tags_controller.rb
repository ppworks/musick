class Users::ArtistItemsTagsController < ApplicationController
  def create
    @artist_item = ArtistItem.find_or_create params[:artist_id], params[:item_asin]
    @tag = Tag.find params[:tag_id]
    current_user.users_artist_items_tags << UsersArtistItemsTag.new(:artist_item_id => @artist_item.id, :tag_id => @tag.id)
  end
  
  def destroy
    @artist_item = ArtistItem.find_or_create params[:artist_id], params[:item_asin]
    @tag = Tag.find params[:tag_id]
    current_user.users_artist_items_tags.where(:artist_item_id => @artist_item.id, :tag_id => params[:tag_id]).delete_all
  end
end
