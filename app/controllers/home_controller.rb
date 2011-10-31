class HomeController < ApplicationController
  def index
    if user_signed_in?
      @users = Rails::cache.fetch('home_controller__index__users', :expires_in => 1.minutes) do
        User.where('current_sign_in_at > ?', 1.days.ago).order('current_sign_in_at DESC').limit(30).all
      end
      render 'index_signed_in'
    else
      render 'index'
    end
  end
  
  def login
    if request.referer =~ Regexp.new(APP_CONFIG[:domain])
      session['user_return_to'] = request.referer
    end
    render :layout => !request.xhr?
  end
end
