class UserVoicesController < ApplicationController
  def create
    UserVoice.create(
      :message => params[:user_voice][:message], 
      :user_id => current_user ? current_user.id : nil,
      :ip_address => request.remote_ip,
      :path => request.path,
      :referer => request.referer,
    )
  end
end
