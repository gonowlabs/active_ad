require 'rubygems'
require 'uri'
require 'httpclient'
require 'tempfile'

%w(advertise attribute helper query tag facet search_result).each do |file|
  require File.expand_path(File.dirname(__FILE__) + "/active_ad/#{file}")
end
