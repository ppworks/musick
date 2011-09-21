class Artist::ItemsController < ApplicationController
  def index
    @artist_items = ArtistItem.find_items params[:artist_id], params[:page]
    render :layout => !request.xhr?
  end
  
  def show
    @artist_item = ArtistItem.find_or_create params[:artist_id], params[:item_asin]
  end
end