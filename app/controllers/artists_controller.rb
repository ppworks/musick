class ArtistsController < ApplicationController
  def index
    @artists = Artist.page params[:page]
  end
end
