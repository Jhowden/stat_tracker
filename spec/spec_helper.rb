require 'rubygems'
require 'rack/test'
require "sinatra/base"
require File.expand_path( "../../config/environment", __FILE__ )

ENV['RACK_ENV'] ||= 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  
  def app
    Rack::Builder.parse_file('config.ru').first
  end
end
