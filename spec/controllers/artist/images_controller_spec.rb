require 'spec_helper'

describe Artist::ImagesController do
  describe "GET 'index'" do
    it "should be success" do
      Artist.stub(:find_images) {{}}
      get 'index', :artist_id => '1', :format => :js
      response.should be_success
    end
  end
end
