class Posts::CommentsController < ApplicationController
  before_filter :authenticate_user!
  def index
    
  end
  
  def create
    @posts_comment = PostsComment.new(params[:posts_comment])
    @posts_comment.post = Post.find params[:id]
    @posts_comment.user = current_user
    
    respond_to do |format|
      res = @posts_comment.remote! params[:provider_id]
      if res
        format.js
      else
        @errors = @posts_comment.errors.full_messages
        format.js {render :template => 'share/exception'}
      end
    end
  end
  
  def destroy
    @posts_comment = PostsComment.find(params[:comment_id])
    
    unless @posts_comment.user.id == current_user.id
      head :status => :unauthorized
      return
    end
    respond_to do |format|
      res = @posts_comment.destroy
      if res
        format.js
      else
        @errors = @posts_comment.errors.full_messages
        format.js {render :template => 'share/exception'}
      end
    end
  end
end