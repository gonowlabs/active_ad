require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveAd::Advertise do

  before :each do
    fakeweb
  end

  it "should init without parameters" do
    subject.class.should eql(ActiveAd::Advertise)
  end

  it "should init given a map of parameters" do
    ActiveAd::Advertise.new(:name => "Jolie").attributes['name'].should eql("Jolie")
  end

  it "should be a new record" do
    ActiveAd::Advertise.new(:title => "Vendo carro").new_record?.should be_true
  end

  it "should return id as nil when new" do
    subject.id.should be_nil
  end

  it "should be a new record when id is null" do
    subject.should be_new_record
  end

  it "should return the errors as ActiveRecord::Errors" do
    subject.errors.class.should eql(ActiveRecord::Errors)
  end

  it "should return tags as Tag objects" do
    ActiveAd::Advertise.find(ADVERTISE_ID).tags.first.should be_a(ActiveAd::Tag)
  end

  it "should respond to new_record?" do
    ActiveAd::Advertise.new(:title => "Vendo carro").new_record?.should be_true
  end

  context "on save" do
    before :each do
      @attributes = {  'dynamic_attributes_attributes' => {
                          "0" => { 'name' => "nome", 'value' => "pedro" },
                          "1" => { 'name' => "", 'value' => "" }},
                        'tag_list' => "car,home" }
      @http_attributes = {"advertise[dynamic_attributes_attributes][0][value]"=>"pedro", "advertise[dynamic_attributes_attributes][1][name]"=>"", "advertise[dynamic_attributes_attributes][0][name]"=>"nome", "advertise[dynamic_attributes_attributes][1][value]"=>"", "advertise[tag_list]"=>"car,home"}
      @document = ActiveAd::Advertise.new(@attributes)
    end

    it "should post attributes" do
      HTTPClient.should_receive(:post).with(json_path_for("advertises"), @http_attributes).and_return(mock_for(new_advertise_json))
      @document.save
    end

    it "should return true when ok" do
      @document.save.should be_true
    end

    it "should set the id" do
      @document.save
      @document.id.should == 2
    end

    it "should update attributes" do
      @document.save
      http_attributes = {"advertise[id]"=>"2", "_method"=>"put", "advertise[tag_list]"=>"imovel"}
      HTTPClient.should_receive(:post).with(json_path_for("advertises/#{@document.id}"), http_attributes).and_return(mock_for(advertise_json))
      @document.update_attributes( :tag_list => "imovel" ).should be_true
    end

    it "should post files as files" do
      file = open_file
      HTTPClient.should_receive(:post) do |path, options|
        options['advertise[files][test]'].should eql(file)
        mock_for(advertise_json)
      end
      ActiveAd::Advertise.new(:files => { :test => file }).save
    end

    it "should post tempfiles as files" do
      file = open_tempfile
      HTTPClient.should_receive(:post) do |path, options|
        options['advertise[files][test]'].should eql(file)
        mock_for(advertise_json)
      end
      ActiveAd::Advertise.new(:files => { :test => file }).save
    end
  end

  context "on find by attribute" do
    it "should find advertises by owner id" do
      attribute, value = "owner_id", "1"
      HTTPClient.stub!(:get).with(json_path_for("find_by_attribute/#{attribute}/#{value}")).and_return(mock_for(latests_json))
      advertises = ActiveAd::Advertise.find_by_attribute(attribute, value)
      advertises.first.should be_instance_of(ActiveAd::Advertise)
    end

  end

  context "on find" do
    it "should get an advertise by an id" do
      id = "14"
      HTTPClient.should_receive(:get).with(json_path_for("advertises/#{id}")).and_return(mock_for(advertise_json))
      ActiveAd::Advertise.find(id)
    end

    it "should return an advertise" do
      ActiveAd::Advertise.find(ADVERTISE_ID).should be_instance_of(ActiveAd::Advertise)
    end

    it "should set attributes" do
      ActiveAd::Advertise.find(ADVERTISE_ID).attributes['created_at'].should eql('2009-08-10T17:52:01Z')
    end

    it "should set the tags" do
      ActiveAd::Advertise.find(ADVERTISE_ID).tag_list.should eql("imoveis,aluguel,flat")
    end

    it "should return the avatar for the default size" do
      ActiveAd::Advertise.find(ADVERTISE_ID).avatar(:default).should eql('/system/avatars/35/default/mohawk.jpg?1258654808')
    end

    it "should return the avatar for the big size" do
      ActiveAd::Advertise.find(ADVERTISE_ID).avatar(:big).should eql('/system/avatars/35/big/mohawk.jpg?1258654808')
    end
  end

  it "should return the id as string on to_param" do
    document = ActiveAd::Advertise.new
    document.save
    document.to_param.should eql("2")
  end

  it "should translate the human name advertise" do
    I18n.stub(:t).with(:'active_ad.advertise').and_return(advertise = "Anunci")
    ActiveAd::Advertise.human_name.should eql(advertise)
  end

  context "when returning a tag list" do
    it "should return an empty String if none exists" do
      subject.tag_list.should be_blank
    end
  end

  context "on dynamic_attributes" do
    it "should return an array of ActiveAd::Attribute objects" do
      subject.dynamic_attributes.first.class.should eql(ActiveAd::Attribute)
    end

    it "should return 2 instances of ActiveAd::Attribute as default" do
      subject.dynamic_attributes.size.should == 2
    end

    it "should return setted dynamic_attributes" do
      ActiveAd::Advertise.find(ADVERTISE_ID).dynamic_attributes.first.name.should eql("Descricao")
    end
  end

  it "should have a dynamic_attributes_attributes setter" do
    subject.dynamic_attributes_attributes=("xpto")
  end

  context "on create!" do
    before :each do
      @tag_list = "car,motor"
      @base = mock(ActiveAd::Advertise, :save => true)
      ActiveAd::Advertise.stub!(:new).with(:tag_list => @tag_list).and_return(@base)
    end

    it "should init and save" do
      @base.should_receive(:save).and_return(true)
      ActiveAd::Advertise.create! :tag_list => @tag_list
    end

    it "should return the created advertise" do
      ActiveAd::Advertise.create!(:tag_list => @tag_list).should eql(@base)
    end

    it "should return new_record? => false" do
      @base.should_receive(:new_record?).and_return(false)
      ActiveAd::Advertise.create!(:tag_list => @tag_list).new_record?.should be_false
    end
  end

  context "on search" do
    before :each do
      @search = ActiveAd::Advertise.search(QUERY)
    end

    it "should return a list of ads found by a query" do
      @search.last.should be_instance_of(ActiveAd::Advertise)
    end

    it "should set the tags" do
      @search.first.tag_list.should eql("casa")
    end

    it "should ignore slashes" do
      query = "car AND plane/boat"
      ActiveAd::Advertise.search(query).should_not be_nil
    end

    it "should return a object with facets" do
      @search.facets['tag'].first.count.should == 7
    end

    it "should paginate results" do
       ActiveAd::Advertise.search(QUERY, :page => 2).first.id.should == 858
    end

    it "should use page 1 as default" do
      ActiveAd::Advertise.search(QUERY, :page => nil).first.id.should == 290
    end

    context "on pagination" do
      before :each do
        @search = ActiveAd::Advertise.search(QUERY, :page => 2)
      end

      it "should return the current page" do
        @search.page.should == 3
      end

      it "should return the number of pages" do
        @search.total_pages.should == 10
      end

      it "should return the total count of documents" do
        @search.count.should == 140
      end
    end
  end

  context "on delete" do
    it "deve enviar um delete" do
      HTTPClient.should_receive(:delete)
      advertise = ActiveAd::Advertise.new
      advertise.destroy
    end
  end

  context "when returning the latests ads" do
    before :each do
      HTTPClient.should_receive(:get).with(json_path_for("advertises/latests")).and_return(mock_for(latests_json))
    end
    it "should return the five results" do
      ActiveAd::Advertise.latests.length.should == 5
    end
    it "should return an array of ActiveAd::Advertise objects" do
      ActiveAd::Advertise.latests.all?{|ad| ad.is_a?(ActiveAd::Advertise)}.should be_true
    end
  end

  it "should return the attachments" do
    url = "/system/files/69/original/iphone.png?1250264108"
    ActiveAd::Advertise.new("attachments_urls" => [url]).attachments.first.should eql(url)
  end

  it "should return the owner" do
    id = '40'
    User.stub!(:find).with(id).and_return(user = User.new)
    ActiveAd::Advertise.new(:owner_id => id).owner.should eql(user)
  end

  it "should return nil as the owner if user_id is nil" do
    subject.owner.should be_nil
  end

  it "should return the description" do
    description = "lorem ipsum"
    ActiveAd::Advertise.new(:description => description).description.should eql(description)
  end

  it "should return the price" do
    price = 0.99
    ActiveAd::Advertise.new(:price => price).price.should eql(price)
  end

  it "should return the hits" do
    hits = 3
    ActiveAd::Advertise.new(:hits => hits).hits.should eql(hits)
  end

  it "should return the title" do
    title = "Best advertise"
    ActiveAd::Advertise.new(:title => title).title.should eql(title)
  end

  it "should have an array of comments" do
    subject.comments.should be_a(Array)
  end

  it "should find advertises for an user by an id" do
    ActiveAd::Advertise.find_by_owner_id(OWNER_ID).page.should == 13
  end

  context "method not exist" do
    before :each do
      @url = "http://test.com"
      @advertise = ActiveAd::Advertise.new
      @advertise.attributes['dynamic_attributes'] = []
      @advertise.attributes['dynamic_attributes'] << {:name => "url", :value => @url}
    end

    it "should have get value from dynamic attributes" do
      @advertise.url.should == @url
    end

    it "should return nil when attribute doesnt exist" do
      @advertise.weight.should be_nil
    end

  end
end

