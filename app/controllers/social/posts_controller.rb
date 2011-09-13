class Social::PostsController < ApplicationController
  before_filter :authenticate_user!
  def new
      render :layout => !request.xhr?
  end

  def create
    opts = {
      :message => params[:content]
    }
    SocialSync.post!(current_user, opts.merge({:provider_id => Provider.facebook})) if params[:facebook].present?
    SocialSync.post!(current_user, opts.merge({:provider_id => Provider.twitter})) if params[:twitter].present?
    SocialSync.post!(current_user, opts.merge({:provider_id => Provider.mixi})) if params[:mixi].present?
  end
end
