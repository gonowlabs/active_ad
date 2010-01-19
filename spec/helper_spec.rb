require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveAd::Helper do
  it "should return the full url for a file" do
    path = "/a/b/c.jpg"
    ActiveAd::Helper.full_url_for(path).should eql("#{ActiveAd::HOST}#{path}")
  end
end
