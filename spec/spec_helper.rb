require 'rubygems'

RAILS_ENV = "test"
RAILS_VERSION = ENV['RAILS_VERSION'] || '2.3.5'

gem 'activesupport', RAILS_VERSION
require 'active_support'

gem 'activerecord', RAILS_VERSION
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

dir = File.dirname(__FILE__)

RAILS_ROOT = File.expand_path(dir)

require File.expand_path(dir + "/../lib/active_ad.rb")

require 'fake_web'

class User
end

def json_from(file)
  File.open("#{DOCS_PATH}/#{file}.json").read
end

def json_path_for(path)
  ActiveAd::Helper.path_for path
end

def new_advertise_json
  json_from "advertise"
end

def advertise_json
  json_from "advertise"
end

def advertises_json
  json_from "advertises"
end

def paginated_advertises_json
  json_from "paginated_advertises"
end

def queries_json
  json_from "queries"
end

def latests_json
  json_from "latests"
end

def tags_json
  json_from "tags"
end

def suggested_attributes_json
  json_from "suggested_attributes"
end

def user_advertises_json
  json_from "user_advertises"
end

def open_file
  File.open(File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb'))
end

def open_tempfile
  Tempfile.new 'spec_helper.rb'
end

TEST_RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

DOCS_PATH = File.expand_path(File.dirname(__FILE__) + '/docs')

ADVERTISE_ID = "49"
QUERY = "plane"
TAG = "blue"
OWNER_ID = "15"

def mock_for(string)
  mock(Object, :body => mock(Object, :content => string))
end

def fakeweb
  HTTPClient.stub!(:post).with(json_path_for("advertises/#{ADVERTISE_ID}"), anything).and_return(mock_for(advertise_json))
  HTTPClient.stub!(:post).with(json_path_for("advertises"), anything).and_return(mock_for(new_advertise_json))
  HTTPClient.stub!(:get).with(json_path_for("advertises/#{ADVERTISE_ID}")).and_return(mock_for(advertise_json))
  HTTPClient.stub!(:get).with(json_path_for("search/#{QUERY}")).and_return(mock_for(advertises_json))
  HTTPClient.stub!(:get).with(json_path_for("search/#{QUERY}") + "?page=2").and_return(mock_for(paginated_advertises_json))
  HTTPClient.stub!(:get).with(json_path_for("suggest/queries/#{QUERY}")).and_return(mock_for(queries_json))
  HTTPClient.stub!(:get).with(json_path_for("advertises/tags")).and_return(mock_for(tags_json))
  HTTPClient.stub!(:get).with(json_path_for("suggest/attributes/#{TAG}")).and_return(mock_for(suggested_attributes_json))
  HTTPClient.stub!(:get).with(json_path_for("suggest/attributes/car%20plane")).and_return(mock_for(suggested_attributes_json))
  HTTPClient.stub!(:get).with(json_path_for("search/car%20AND%20plane%20boat")).and_return(mock_for(advertises_json))
  HTTPClient.stub!(:get).with(json_path_for("search/owner_id:#{OWNER_ID}")).and_return(mock_for(user_advertises_json))
end
