class User::HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    logger.info Invite.counter_hash(:user_id => current_user.id, :provider_id => Provider.facebook.id)
  end
end