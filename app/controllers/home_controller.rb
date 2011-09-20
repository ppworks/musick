class HomeController < ApplicationController
  def index
    if user_signed_in?
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
