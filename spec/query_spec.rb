require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveAd::Query do
  before :each do
    fakeweb
  end

  it "should return suggested queries" do
    ActiveAd::Query.suggest(QUERY).last.name.should eql("casa")
  end

  it "should return the number of times a query was searched" do
    ActiveAd::Query.suggest(QUERY).first.count.should eql(13)
  end

  it "should return the results count" do
    ActiveAd::Query.suggest(QUERY).first.results_count.should eql(34)
  end
end
