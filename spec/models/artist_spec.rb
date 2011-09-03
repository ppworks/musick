require 'spec_helper'

describe Artist do
  describe 'aritist data' do
    it 'artist should have name' do
      artist = Factory(:artist_larc)
      artist.name.should be_instance_of(String)
    end
  end
end