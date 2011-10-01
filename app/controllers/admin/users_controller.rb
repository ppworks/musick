class Admin::UsersController < Admin::ApplicationController
  def index
    User.paginates_per 20
    @users = User.includes(:posts).order('id DESC').page(params[:page])
  end
  
  def login
    user = User.find_by_id(params[:id])
    unless user.blank?
      sign_in(:user, user)
      session[:is_hijack] = true
    end
    redirect_to root_path
  end
end
