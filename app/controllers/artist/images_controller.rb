class Artist::ImagesController < ApplicationController
  def index
    @artist_images = Artist.find_images(params[:artist_id])
  end
  
  def show
    @artist_image = ArtistImage.includes(:artist).find params[:id]
    @image_size = @artist_image.get_image_size
    render :layout => !request.xhr?
  end
end