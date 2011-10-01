require 'spec_helper'

describe Artist::ItemesController do
  describe "GET 'index'" do
    it "should be success" do
      ArtistItem.stub(:find_items) {{}}
      get 'index', :artist_id => '1'
      response.should be_success
    end
  end
  
  describe "GET 'show'" do
    it "should be success" do
      ArtistItem.stub(:find_or_create) {{}}
      get 'show', :artist_id => '1', :item_asin => 'XXXX'
      response.should be_success
    end
  end
end
