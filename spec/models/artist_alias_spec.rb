require 'spec_helper'

describe ArtistAlias do
  describe 'aritist alias data' do
    it 'artist alias should have name' do
      artist_alias = Factory(:artist_alias_larc)
      artist_alias.name.should be_instance_of(String)
    end
  end
end
