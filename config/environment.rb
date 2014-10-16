# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# # Basic CAS client configuration
#
# require 'casclient'
# require 'casclient/frameworks/rails/filter'
#
# CASClient::Frameworks::Rails::Filter.configure(
#     :cas_base_url => "CAS URL"
# )
