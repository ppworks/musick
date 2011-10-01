require 'spec_helper'

describe Social::FriendsController do
  describe "GET 'index'" do
    login_user
    it "should be successful" do
      Social::Friend.stub(:fetch) {[]}
      get 'index', :provider => 'facebook'
      response.should be_success
    end
  end
  
  describe "POST 'invite'" do
    login_user
    it "should be successful" do
      Invite.stub(:send_to_friends) {{}}
      post 'invite', :provider => 'facebook', :to_provider_user_keys => 'user_key', :format => :js
      response.should be_success
    end
  end
end
