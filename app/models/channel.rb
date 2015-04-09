class Channel < ActiveRecord::Base
  serialize :owners, Array
  serialize :projects, Array
  serialize :regexes, Array
end
