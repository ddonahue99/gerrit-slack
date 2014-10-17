class Alias < ActiveRecord::Base

   def self.slack_name_for(user)
     anonym = find_by(gerrit_username: user)
     anonym ? anonym.slack_username : user
   end
end
