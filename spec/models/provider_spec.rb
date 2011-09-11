require 'spec_helper'

describe Provider do
  it 'provider has 3 providers' do
    Provider.all.count.should == 3
  end
end
