class Stream::ClipController < ApplicationController
  def artist
    @users_artists = UsersArtist
      .includes(:artist)
    if params[:filters] =~ /other/ && current_user.present?
      @users_artists = @users_artists.where(['user_id <> ?', current_user.id])
    end
    if params[:filters] =~ /user([0-9]+)/
      @users_artists = @users_artists.where(['user_id = ?', $1])
    end
    @users_artists = @users_artists
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
  end
  
  def artist_item
    @users_artist_items = UsersArtistItem
      .includes(:artist_item)
    if params[:filters] =~ /user([0-9]+)/
      @users_artist_items = @users_artist_items.where(['user_id = ?', $1])
    end
    if params[:filters] =~ /artist([0-9]+)/
      @users_artist_items = @users_artist_items.where(['artist_items.artist_id = ?', $1])
      @users_artist_items = @users_artist_items.group('users_artist_items.artist_item_id')
    end
    if params[:filters] =~ /other/ && current_user.present?
      @users_artist_items = @users_artist_items.where(['user_id <> ?', current_user.id])
    end
    @users_artist_items = @users_artist_items
      .order('users_artist_items.id DESC')
      .page(params[:page])
      .per(params[:per])
  end
  
  def artist_track
    @users_artist_tracks = UsersArtistTrack
      .includes(:artist_track)
    if params[:filters] =~ /user([0-9]+)/
      @users_artist_tracks = @users_artist_tracks.where(['user_id = ?', $1])
    end
    if params[:filters] =~ /artist([0-9]+)/
      @users_artist_tracks = @users_artist_tracks.where(['artist_tracks.artist_id = ?', $1])
      @users_artist_tracks = @users_artist_tracks.group('users_artist_tracks.artist_track_id')
    end
    if params[:filters] =~ /other/ && current_user.present?
      @users_artist_tracks = @users_artist_tracks.where(['user_id <> ?', current_user.id])
    end
    @users_artist_tracks = @users_artist_tracks
      .order('users_artist_tracks.id DESC')
      .page(params[:page])
      .per(params[:per])
  end
end
