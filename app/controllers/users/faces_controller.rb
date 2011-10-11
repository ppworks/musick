class Users::FacesController < ApplicationController
  def index
    @users = Rails::cache.fetch('users_faces_controller_index', :expires_in => 5.minutes) do
      User.order('current_sign_in_at DESC').all
    end
  end
end
