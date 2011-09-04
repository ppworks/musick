require 'spec_helper'

describe LastfmWrapper::Base do
  describe 'setting' do
    it 'api should be isntace of Lastfm' do
      res = LastfmWrapper::Base.api.should be_instance_of(Lastfm)
    end
  end
end
