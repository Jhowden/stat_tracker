ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'

require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?

require 'sinatra/form_helpers'

require 'erb'

APP_ROOT = Pathname.new( File.expand_path('../../', __FILE__ ) )

APP_NAME = APP_ROOT.basename.to_s

Dir[APP_ROOT.join( 'app', 'controllers', '*.rb' )].each { |file| require file }
Dir[APP_ROOT.join( 'app', 'models', "actions", '*.rb' )].each { |file| require file }
Dir[APP_ROOT.join( 'app', "repository", '*.rb' )].each { |file| require file }
Dir[APP_ROOT.join( 'app', 'models', "helpers", '*.rb' )].each { |file| require file }

require APP_ROOT.join( 'config', 'database' )