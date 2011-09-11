class ArtistsController < ApplicationController
  def index
    @artists = Artist.page params[:page]
  end
  
  def show
    @artist = Artist.show.find params[:id]
  end
  
  def search
    keyword = params[:keyword]
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
    artists = Artist.create_by_lastfm(LastfmWrapper::Artist.search params[:keyword], {:limit => LastfmWrapper::Artist::SEARCH_LIMIT})
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
