require 'spec_helper'

describe SocialUser::Provider do
  it 'provider has 3 providers' do
    SocialUser::Provider.all.count.should == 3
  end
end
