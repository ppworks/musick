class Posts::LikesController < ApplicationController
  before_filter :authenticate_user!
  def index
    
  end
  
  def create
    @post = Post.find params[:id]
    @provider = Provider.find params[:provider_id]
    @posts_like = PostsLike.new()
    @posts_like.post = @post
    @posts_like.user = current_user
    
    respond_to do |format|
      res = @posts_like.like_remote! params[:provider_id]
      if res
        @post.reload
        format.js
      else
        @errors = @posts_like.errors.full_messages
        format.js {render :action => 'share/exception'}
      end
    end
  end
  
  def destroy
    @post = Post.find params[:id]
    @provider = Provider.find params[:provider_id]
    user_key = current_user.providers_users.where(:provider_id => params[:provider_id]).first.user_key
    # OPTIMIZE: too long find_by_xxxx
    @posts_like = PostsLike
      .find_by_provider_id_and_post_id_and_user_key params[:provider_id], params[:id], user_key
   
    unless @posts_like.user_id == current_user.id
      head :status => :unauthorized
      return
    end
    
    respond_to do |format|
      res = @posts_like.unlike_remote! params[:provider_id]
      if res
        @post.reload
        format.js
      else
        @errors = @posts_like.errors.full_messages
        format.js {render :action => 'share/exception'}
      end
    end
  end
end