class Artist::ItemsController < ApplicationController
  def index
    @items = ArtistItem.find_items params[:artist_id], params[:page]
  end
end