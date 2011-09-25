class Providers::ProfilesController < ApplicationController
  before_filter :authenticate_user!
  def index
    provider_id = params[:id]
    if params[:user_keys].nil?
      head :not_found
      return
    end
    
    user_keys = params[:user_keys].split(',')
    @provider_id = provider_id
    # TODO:cache parameter move to config
    case provider_id.to_i
    when Provider.mixi.id
      @profiles = ProviderProfile
        .where(:provider_id => provider_id)
        .where(:user_key => user_keys)
        .all
      provider_name = 'mixi'
    when Provider.facebook.id
      @profiles = Rails.cache.fetch("providers:" + provider_id + ":" + params[:user_keys], :expires_in => 30.minutes) do
        SocialSync.profiles current_user, {:provider_id => provider_id, :uid => user_keys}
      end
      provider_name = 'facebook'
    end
    respond_to do |format|
      format.js {render provider_name}
    end
  end
end