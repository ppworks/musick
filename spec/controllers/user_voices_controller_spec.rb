require 'spec_helper'

describe UserVoicesController do

  describe "GET 'create'" do
    it "should be successful" do
      get 'create', :format => :js
      response.should be_success
    end
  end

end
