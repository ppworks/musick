class ArtistsController < ApplicationController
  def index
    @artists = Artist.page params[:page]
  end
  
  def show
    @artist = Artist.find params[:id]
  end
  
  def search
    @artists = Artist
      .search_name(params[:keyword])
      .page params[:page]
  end
end
