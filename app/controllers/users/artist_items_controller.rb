class Users::ArtistItemsController < ApplicationController
  def create
    artist_item = ArtistItem.find_or_create params[:artist_id], params[:item_asin]
    current_user.artist_items << artist_item
  end
  
  def destroy
    artist_item = ArtistItem.find_or_create params[:artist_id], params[:item_asin]
    current_user.artist_items.delete artist_item
  end
  
  def index
    user = User.find params[:user_id]
    user.artist_items.paginates_per(10)
    @artist_items = user.artist_items.order("users_artist_items.priority, users_artist_items.id DESC").page(params[:page])
    render :layout => !request.xhr?
  end
end
