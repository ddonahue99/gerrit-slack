require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'yaml'
require 'json'

require_relative 'lib/update'
require_relative 'lib/gerrit_notifier'
