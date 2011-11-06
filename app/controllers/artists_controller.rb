class ArtistsController < ApplicationController
  def index
    @artists = Artist.page params[:page]
  end
  
  def show_redirect
    redirect_to "/artist/#{params[:id]}", :status=>301
  end
  
  def show
    @artist = Artist.find_and_update_lastfm params[:id]
    @users_artists = UsersArtist.includes(:user).where(:artist_id => params[:id]).order('updated_at DESC').limit(16).all
    @users_artists_tags = UsersArtistsTag.includes(:tag).includes(:user).where(:artist_id => params[:id]).order('updated_at DESC').limit(16).all
  end
  
  def search
    keyword = params[:keyword]
    SearchLog.log(:user => current_user, :keyword => keyword, :kind => SearchLog::ARTIST)
    @artists = Artist
      .search_name(params[:keyword])
      .page params[:page]
    if @artists.blank?
      search_lastfm
    end
    respond_to do |format|
      format.js
      format.html {render 'index'}
    end
  end
  
  def search_lastfm
    @artists = @artists || []
    artists = Artist.create_by_lastfm(params[:keyword])
    @artists = @artists + artists
    @artists.instance_eval <<-EVAL
      def current_page
        #{params[:page] || 1}
      end
      def num_pages
        count
      end
      def limit_value
        #{LastfmWrapper::Artist::SEARCH_LIMIT}
      end
    EVAL
  end
end
