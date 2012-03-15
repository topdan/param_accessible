require 'rubygems'
require 'bundler/setup'

require "#{File.dirname(__FILE__)}/app_root/config/environment"

require 'simplecov'
SimpleCov.start do
  add_filter do |src|
    src.filename =~ /\/spec\//
  end
end

require 'rspec'
require 'rspec/rails'
require 'param_accessible'
