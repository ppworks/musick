require 'spec_helper'

describe ArtistImage do
  describe 'aritist image data' do
    it 'artist image should have url' do
      artist_image = Factory(:artist_image_larc)
      artist_image.url.should be_instance_of(String)
    end
  end
end
