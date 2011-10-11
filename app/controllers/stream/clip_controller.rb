class Stream::ClipController < ApplicationController
  def artist
    @users_artists = UsersArtist
      .includes(:artist)
    if params[:filters] =~ /other/ && current_user.present?
      @users_artists = @users_artists.where(['user_id <> ?', current_user.id])
    end
    @users_artists = @users_artists
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
  end
  
  def artist_item
    @users_artist_items = UsersArtistItem
      .includes(:artist_item)
    if params[:filters] =~ /other/ && current_user.present?
      @users_artist_items = @users_artist_items.where(['user_id <> ?', current_user.id])
    end
    @users_artist_items = @users_artist_items
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
  end
  
  def artist_track
    @users_artist_tracks = UsersArtistTrack
      .includes(:artist_track)
    if params[:filters] =~ /other/ && current_user.present?
      @users_artist_tracks = @users_artist_tracks.where(['user_id <> ?', current_user.id])
    end
    @users_artist_tracks = @users_artist_tracks
      .order('id DESC')
      .page(params[:page])
      .per(params[:per])
  end
end
