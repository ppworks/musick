class Stream::PostController < ApplicationController
  def all
    @posts = Post
      .includes(:user)
      .includes(:posts_likes)
      .includes(:posts_artist)
      .includes(:posts_artist_image)
      .includes(:posts_artist_item)
      .includes(:posts_artist_track)
    
    if params[:filters] =~ /other/ && current_user.present?
      @posts = @posts.where(['user_id <> ?', current_user.id])
    end
    if params[:filters] =~ /user([0-9]+)/
      @posts = @posts.where(['user_id = ?', $1])
    end
    @posts = @posts
      .exists
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
  end
  
  def artist
    @posts = Post
      .includes(:user)
      .includes(:posts_likes)
      .includes(:posts_artist)
      .includes(:posts_artist_image)
      .includes(:posts_artist_item)
      .includes(:posts_artist_track)
    
    if params[:filters] =~ /other/ && current_user.present?
      @posts = @posts.where(['user_id <> ?', current_user.id])
    end
    if params[:filters] =~ /artist([0-9]+)/
      @posts = @posts.joins(:posts_artist).where(['posts_artists.artist_id = ?', $1])
    end
    @posts = @posts
      .exists
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
    render 'all'
  end
  
  def artist_item
    @posts = Post
      .includes(:user)
      .includes(:posts_likes)
      .includes(:posts_artist)
      .includes(:posts_artist_image)
      .includes(:posts_artist_item)
      .includes(:posts_artist_track)
    
    if params[:filters] =~ /other/ && current_user.present?
      @posts = @posts.where(['user_id <> ?', current_user.id])
    end
    if params[:filters] =~ /artist_item([0-9]+)/
      @posts = @posts.joins(:posts_artist_item).where(['posts_artist_items.artist_item_id = ?', $1])
    end
    @posts = @posts
      .exists
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
    render 'all'
  end
  
  def artist_track
    @posts = Post
      .includes(:user)
      .includes(:posts_likes)
      .includes(:posts_artist)
      .includes(:posts_artist_image)
      .includes(:posts_artist_item)
      .includes(:posts_artist_track)
    
    if params[:filters] =~ /other/ && current_user.present?
      @posts = @posts.where(['user_id <> ?', current_user.id])
    end
    if params[:filters] =~ /artist_track([0-9]+)/
      @posts = @posts.joins(:posts_artist_track).where(['posts_artist_tracks.artist_track_id = ?', $1])
    end
    @posts = @posts
      .exists
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
    render 'all'
  end
end
