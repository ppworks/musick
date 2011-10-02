class UserVoicesController < ApplicationController
  def create
    user_voice = params[:user_voice]
    UserVoice.create(
      :message => user_voice ? user_voice[:message] : '', 
      :user_id => current_user ? current_user.id : nil,
      :ip_address => request.remote_ip,
      :path => request.path,
      :referer => request.referer,
    )
  end
end
