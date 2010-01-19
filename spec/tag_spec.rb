require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveAd::Tag do
  before :each do
    fakeweb
  end

  it "should return a cloud as an array" do
    ActiveAd::Tag.cloud.last.class.should eql(ActiveAd::Tag)
  end

  it "should return the name" do
    ActiveAd::Tag.cloud.last.name.should eql("motor")
  end

  it "should return the count" do
    ActiveAd::Tag.cloud.last.count.should eql(12)
  end
end
