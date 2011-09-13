class Artist::ImagesController < ApplicationController
  def index
    @artist_images = Artist.find_images(params[:artist_id])
  end
end