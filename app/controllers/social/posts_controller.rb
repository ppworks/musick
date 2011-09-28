class Social::PostsController < ApplicationController
  before_filter :authenticate_user!
  def new
    render :layout => !request.xhr?
  end
  
  def new_with_action
    
    target_object = params["data-target-object"]||''
    target_object = target_object.pluralize
    target_attributes = params["data-target-attributes"]||[].to_yaml
    target_attributes = YAML.load target_attributes
    @link_to_clip_helper = "link_to_users_#{target_object}_create_or_destroy"
    @clip_helper_params = target_attributes
    render :layout => !request.xhr?
  end

  def create
    opts = {
      :message => params[:content]
    }
    SocialSync.post!(current_user, opts.merge({:provider_id => Provider.facebook.id})) if params[:facebook].present?
    SocialSync.post!(current_user, opts.merge({:provider_id => Provider.twitter.id})) if params[:twitter].present?
    SocialSync.post!(current_user, opts.merge({:provider_id => Provider.mixi.id})) if params[:mixi].present?
  end
  
  def create_with_action
    action = 'post'
    target_object = params["data-target-object"]||''
    target_attributes = params["data-target-attributes"]||[].to_yaml
    post_method = "#{action}_#{target_object}"
    
    provider_ids = []
    provider_ids << Provider.facebook.id if params[:facebook].present?
    provider_ids << Provider.twitter.id if params[:twitter].present?
    provider_ids << Provider.mixi.id if params[:mixi].present?
    @post = Post.new(:content => params[:content])
    @post.user = current_user
    
    if @post.respond_to? post_method
      social_post_params = @post.send post_method, target_attributes, params[:content]
    else 
      social_post_params = {}
    end
    respond_to do |format|
      begin
        if provider_ids.present?
          res = @post.remote! provider_ids, social_post_params
        else
          res = @post.create!
        end
        if res
          format.js {render :action => 'create'}
        else
          @errors = @post.errors.full_messages
          format.js {render :template => 'share/exception'}
        end
      rescue => e
        logger.error e.message
        @errors = [e.message]
        format.js {render :template => 'share/exception'}
      end
    end
  end
end
