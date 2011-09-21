class Users::FriendsController < ApplicationController
  before_filter :authenticate_user!
  def index
    user = User.find params[:user_id]
    @friends = user.follows
  end

end
