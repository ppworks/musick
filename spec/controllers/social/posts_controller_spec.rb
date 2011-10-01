require 'spec_helper'

describe Social::PostsController do

  describe "GET 'new'" do
    login_user
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'new_with_action'" do
    login_user
    it "should be successful" do
      get 'new_with_action'
      response.should be_success
    end
  end
  
  describe "POST 'create'" do
    login_user
    it "should be successful" do
      post 'create', :format => :js
      response.should be_success
    end
  end
  
  describe "POST 'create_with_action'" do
    login_user
    it "should be successful" do
      post 'create_with_action', :format => :js, :content => 'post test'
      response.should be_success
    end
  end
end
