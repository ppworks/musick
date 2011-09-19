class Social::FriendsController < ApplicationController
  before_filter :authenticate_user!
  def index
    provider = params[:provider]
    if provider.nil?
      redirect_to social_friends_path(current_user.default_provider.name)
      return
    end
    @profiles = Social::Friend.fetch :current_user => current_user, :provider => provider
    render :layout => !request.xhr?
  end
  
  def invite
    if params[:to_provider_user_keys].blank?
      @errors = [I18n.t('attributes.to_user_key') + I18n.t('support.select.prompt')]
      render 'share/exception'
      return
    end
    if params[:to_provider_user_keys].split(',').length > Invite::INVITE_USER_MAX
      @errors = [I18n.t('attributes.to_user_key') + I18n.t('errors.messages.less_than_or_equal_to', :count => Invite::INVITE_USER_MAX.to_s + I18n.t('musick.people'))]
      render 'share/exception'
      return
    end
    
    res = Invite.send_to_friends :current_user => current_user, :params => params
    if res[:errors].present?
      @errors = res[:errors].full_messages
      render 'share/exception'
      return
    end
  end
end
