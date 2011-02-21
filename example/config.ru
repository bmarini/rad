require 'rubygems'
require 'bundler/setup'
require 'rad'

# Rad::App.set :radfile, File.expand_path("../../spec/fixtures/Radfile", __FILE__)
Rad::App.set :radfile, File.expand_path("../Radfile", __FILE__)
run Rad::App