class Stream::ClipController < ApplicationController
  def artist
    UsersArtist.paginates_per(6)
    @users_artists = UsersArtist
      .includes(:artist)
      .where(['user_id <> ?', current_user.id])
      .order('id DESC')
      .page(params[:page])
      .all
  end
  
  def artist_item
    UsersArtistItem.paginates_per(6)
    @users_artist_items = UsersArtistItem
      .includes(:artist_item)
      .where(['user_id <> ?', current_user.id])
      .order('id DESC')
      .page(params[:page])
      .all
  end
  
  def artist_track
    UsersArtistTrack.paginates_per(6)
    @users_artist_track = UsersArtistTrack.order('id DESC').page(params[:page]).first
  end
end
