require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'yaml'
require 'json'

require_relative 'lib/alias'
require_relative 'lib/update'
require_relative 'lib/channel_config'
require_relative 'lib/gerrit_notifier'
