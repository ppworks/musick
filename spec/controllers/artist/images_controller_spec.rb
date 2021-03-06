require 'spec_helper'

describe Artist::ImagesController do
  describe "GET 'index'" do
    it "should be success" do
      Artist.stub(:find_images) {{}}
      get 'index', :artist_id => '1', :format => :js
      response.should be_success
    end
  end
  
  describe "GET 'show'" do
    it "should be success" do
      artist_image = Factory.create(:artist_image_larc)
      get 'show', :artist_id => artist_image.artist.id, :id => artist_image.id
      response.should be_success
    end
  end
end
