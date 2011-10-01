class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!, :admin_user_check
  
  protected
  def admin_user_check
    head :unauthorized
  end
end
