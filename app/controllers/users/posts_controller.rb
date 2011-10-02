class Users::PostsController < ApplicationController
  before_filter :authenticate_user!
  def index
    begin
      @user = User.find params[:user_id]
      @posts = @user.posts
        .includes(:user)
        .includes(:posts_likes)
        .includes(:posts_artist)
        .includes(:posts_artist_image)
        .includes(:posts_artist_item)
        .includes(:posts_artist_track)
        .order('id DESC')
        .page params[:page]
    rescue ActiveRecord::RecordNotFound => e
      head :status => :not_found
    end
  end
end