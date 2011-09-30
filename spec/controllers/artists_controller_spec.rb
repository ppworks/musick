require 'spec_helper'

describe ArtistsController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      artist = Factory.create :artist_larc
      Artist.stub(:find_and_update_lastfm) {artist}
      get 'show', :id => 1
      response.should be_success
    end
  end
  
  describe "GET 'search'" do
    it "should be successful" do
      artist = Factory.create :artist_larc
      get 'search', :keyword => "L'Arc~en~Ciel"
      response.should be_success
    end
  end
  
  describe "GET 'search_lastfm'" do
    it "should be successful" do
      artist = Factory.create :artist_larc
      Artist.stub(:create_by_lastfm) {[artist]}
      get 'search_lastfm', :keyword => "L'Arc~en~Ciel", :format => :js
      response.should be_success
    end
  end
end
