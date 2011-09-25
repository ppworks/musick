class Posts::CommentsLikesController < ApplicationController
  before_filter :authenticate_user!
  def index
    
  end
  
  def create
    @posts_comment = PostsComment.find params[:comment_id]
    @provider = Provider.find params[:provider_id]
    @posts_comments_like = PostsCommentsLike.new()
    @posts_comments_like.posts_comment = @posts_comment
    @posts_comments_like.user = current_user
    
    respond_to do |format|
      res = @posts_comments_like.like_remote! params[:provider_id]
      if res
        @posts_comment.reload
        format.js
      else
        @errors = @posts_comments_like.errors.full_messages
        format.js {render :action => 'share/exception'}
      end
    end
  end
  
  def destroy
    @posts_comment = PostsComment.find params[:comment_id]
    @provider = Provider.find params[:provider_id]
    user_key = current_user.providers_users.where(:provider_id => params[:provider_id]).first.user_key
    # OPTIMIZE: too long find_by_xxxx
    @posts_comments_like = PostsCommentsLike
      .find_by_provider_id_and_posts_comment_id_and_user_key params[:provider_id], params[:comment_id], user_key
   
    unless @posts_comments_like.user_id == current_user.id
      head :status => :unauthorized
      return
    end
    
    respond_to do |format|
      res = @posts_comments_like.unlike_remote! params[:provider_id]
      if res
        @posts_comment.reload
        format.js
      else
        @errors = @posts_comments_like.errors.full_messages
        format.js {render :action => 'share/exception'}
      end
    end
  end
end