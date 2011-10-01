require 'spec_helper'

describe Users::FriendsController do
  describe "GET 'index'" do
    login_user
    it "should be successful" do
      get 'index', :user_id => "1"
      response.should be_success
    end
  end
end
