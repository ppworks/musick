require 'spec_helper'

describe LastfmWrapper::Artist do
  describe 'search on last.fm' do
    it 'empty search results' do
      keyword = 'uhohofafmabie'
      mock_artist = []
      LastfmWrapper::Artist.should_receive(:search).with(keyword).and_return(mock_artist)
      res = LastfmWrapper::Artist.search keyword
      res.size.should == 0
    end
    it 'search results' do
      keyword = 'Cher'
      mock_artist = [{
        :name => 'Cher', 
        :mbid => 'bfcc6d75-a6a5-4bc6-8282-47aec8531818', 
        :url => 'http://www.last.fm/music/Cher'
      }]
      LastfmWrapper::Artist.should_receive(:search).with(keyword).and_return(mock_artist)
      res = LastfmWrapper::Artist.search keyword
      res.size.should == 1
      res[0][:name].should == mock_artist[0][:name]
      res[0][:mbid].should == mock_artist[0][:mbid]
      res[0][:url].should == mock_artist[0][:url]

    end
  end
end
