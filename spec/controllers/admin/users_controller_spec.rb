require 'spec_helper'

describe Admin::UsersController do
  describe "GET 'index'" do
    login_user
    it "should be unauthorized" do
      get 'index'
      response.should be_client_error
    end
  end
end
