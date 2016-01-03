require 'rubygems'
require 'rack/test'
require "database_cleaner"
require File.expand_path( "../../config/environment", __FILE__ )

ENV['RACK_ENV'] ||= 'test'

RSpec.configure do |config|
  ActiveRecord::Base.logger = nil unless ENV['LOG'] == true
  config.include Rack::Test::Methods
  
  def app
    Rack::Builder.parse_file('config.ru').first
  end
  
  config.before(:suite) do
     DatabaseCleaner.strategy = :transaction
     DatabaseCleaner.clean_with(:truncation)
   end
   
    config.before(:each) do
     DatabaseCleaner.start
   end
     
    config.after(:each) do
     DatabaseCleaner.clean
   end
end
