require 'spec_helper'

describe ArtistImage do
  describe 'aritist image data' do
    it 'artist image should have url' do
      artist_image = Factory(:artist_image_larc)
      artist_image.original.should be_instance_of(String)
      artist_image.large.should be_instance_of(String)
      artist_image.largesquare.should be_instance_of(String)
      artist_image.medium.should be_instance_of(String)
      artist_image.small.should be_instance_of(String)
      artist_image.extralarge.should be_instance_of(String)
    end
  end
end
