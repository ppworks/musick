class User::ArtistsController < ApplicationController
  before_filter :authenticate_user!
  def follow
    current_user.follow_artists << Artist.find(params[:id])
  end

  def unfollow
    current_user.follow_artists.delete Artist.find(params[:id])
  end
end
