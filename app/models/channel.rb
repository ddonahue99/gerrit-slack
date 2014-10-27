class Channel < ActiveRecord::Base
  serialize :owners, Array
  serialize :projects, Array
end
