class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    user_ids = current_user.follows + [current_user.id]
    @posts = Post
      .includes(:user)
      .includes(:posts_likes)
      .includes(:posts_artist)
      .includes(:posts_artist_image)
      .includes(:posts_artist_item)
      .includes(:posts_artist_track)
      .where(:user_id => user_ids)
      .exists
      .order('id DESC')
      .page params[:page]
  end
  
  def show
    @post = Post.includes(:posts_likes).where(:id => params[:id]).exists.first
    if @post.blank?
      head :status => :not_found
    end
  end
  
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    respond_to do |format|
      begin
        res = @post.remote!
        if res
          format.js
        else
          @errors = @post.errors.full_messages
          format.js {render :action => 'share/exception'}
        end
      rescue => e
        logger.error e.message
        format.js
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    unless @post.user.id == current_user.id
      head :status => :unauthorized
      return
    end
    respond_to do |format|
      begin
        @post.show_flg = FALSE
        res = @post.save
        if res
          format.js
        else
          @errors = @post.errors.full_messages
          format.js {render :action => 'share/exception'}
        end
      rescue => e
        logger.error e.message
        format.js
      end
    end
  end
  
  def sync
    @post = Post.find params[:id]
    res = @post.sync!
    unless res
      head :ok
      return
    end
    respond_to do |format|
      format.js
    end
  end
end
