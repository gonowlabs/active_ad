require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveAd::Attribute do
  before :each do
    fakeweb
  end

  %w(name value).each do |attr|
    it "should have a #{attr} getter" do
      ActiveAd::Attribute.new.send attr
    end
  end

  it "should identify is a new record" do
    ActiveAd::Attribute.new.should be_new_record
  end

  it "should init with a name" do
    name = "Carl"
    ActiveAd::Attribute.new(:name => name).name.should eql(name)
  end

  it "should init with a value" do
    value = "Joe"
    ActiveAd::Attribute.new(:value => value).value.should eql(value)
  end

  context "when suggesting" do
    before :each do
      @attributes = ActiveAd::Attribute.suggest(TAG)
    end

    it "should return an array of attributes" do
      @attributes.last.should be_instance_of(ActiveAd::Attribute)
    end

    it "should set the name in each attribute" do
      @attributes.first.name.should eql("Descricao")
    end

    it "should escape blank characters" do
      ActiveAd::Attribute.suggest("car plane").first.name.should eql("Descricao")
    end
  end
end
