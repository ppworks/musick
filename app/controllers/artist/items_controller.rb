class Artist::ItemsController < ApplicationController
  def index
    _search
  end
  
  def show
    @artist_item = ArtistItem.find_or_create params[:artist_id], params[:item_asin]
    @users_artist_items = UsersArtistItem.includes(:user).where(:artist_item_id => @artist_item.id).order('updated_at DESC').limit(16).all
    @users_artist_items_tags = UsersArtistItemsTag.includes(:tag).includes(:user).where(:artist_item_id => @artist_item.id).order('updated_at DESC').limit(16).all
    render :layout => !request.xhr?
  end
  
  def search
    keyword = params[:keyword] || ''
    @artist = Artist.where(:id => params[:artist_id]).first
    _search keyword
  end
  
  protected
  def _search keyword = ''
    @artist_id = params[:artist_id]
    @artist_items = ArtistItem.find_items params[:artist_id], params[:page], keyword
    SearchLog.log(:user => current_user, :keyword => keyword, :kind => SearchLog::ARTIST_ITEM, :target_id => @artist_id)
    render :layout => !request.xhr?
  end
end