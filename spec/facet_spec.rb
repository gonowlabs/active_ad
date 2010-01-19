require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveAd::Facet do
  before :each do
    fakeweb
  end

  it "should set the count as numeric" do
    ActiveAd::Facet.new(:count => "5").count.should == 5
  end

  it "should set the name" do
    ActiveAd::Facet.new(:name => "house").name.should == "house"
  end
end
