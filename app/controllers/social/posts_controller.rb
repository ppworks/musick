class Social::PostsController < ApplicationController
  before_filter :authenticate_user!
  def new
    render :layout => !request.xhr?
  end
  
  def new_with_action
    target_action = params["data-action"]||''
    target_object = params["data-target-object"]||''
    target_object = target_object.pluralize
    target_attributes = params["data-target-attributes"]||[].to_yaml
    target_attributes = YAML.load target_attributes
    @link_to_helper = "link_to_users_#{target_object}_#{target_action}"
    @helper_params = target_attributes
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
