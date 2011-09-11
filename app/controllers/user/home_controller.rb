class User::HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    
  end
end