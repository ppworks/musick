class ArtistsController < ApplicationController
  def index
    @artists = Artist.page params[:page]
  end
  
  def show
    @artist = Artist.find params[:id]
  end
  
  def search
    @artists = Artist
      .search_name(params[:keyword])
      .page params[:page]
    if params[:page].nil? && @artists.blank?
      logger.info "fetch last.fm"
      begin
        res = Artist.fetch_lastfm params[:keyword]
      rescue Lastfm::ApiError => e
        logger.info e.message
      end
      if res.present?
        logger.info 'created by last.fm fetch.'
        @artists = [res]
        @artists.instance_eval <<-EVAL
          def current_page
            #{params[:page] || 1}
          end
          def num_pages
            count
          end
          def limit_value
            20
          end
        EVAL
      end
    end
  end
end
