class HomeController < ApplicationController
  def index
    if user_signed_in?
      render 'index_signed_in'
    else
      render 'index'
    end
  end
end
