class Users::PostsController < ApplicationController
  before_filter :authenticate_user!
  def index
    begin
      @user = User.find params[:user_id]
      @posts = @user.posts
        .order('id DESC')
        .page params[:page]
    rescue ActiveRecord::RecordNotFound => e
      head :status => :not_found
    end
  end
end