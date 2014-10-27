# Gerritbot UI
Gerritbot UI uses Rails Admin for the UI, Devise for the authentication, and CanCan for the authorization. Rails Admin can be found here: [https://github.com/sferik/rails_admin]
## RUNNING GERRITBOT
You will have to run 
```ruby
bundle exec rake run_notifier
``` 
from the root directory to enable the Gerrit listener in addition to running this app.
## DATA INPUT
The "Projects" and "Owners" fields accept arrays. The emoji fields are text fields.
## RAILS_ADMIN
There are three user "types": regular users, admin users, and superadmin users.
### Users
Can read and access the dashboard
### Admins
Admins can manage (read and write) Channel and Alias, but not destroy them. You can change this in app/model/ability.rb - look at the CanCan documentation for syntax
### Superadmins
Can manage everything. Because they are super.
--- 
## EMOJIS
Emojis are text fields. Enter in emojis like this:
```
:tada: :crystal_ball:
```
Currently, the emoji fields don't hide if the checkbox is not checked, but the emoji fields are optional. If you leave them blank, it won't hurt Gerritbot.
--- 
## TO DO
There is a lot left to do for Gerritbot, like fixing/writing specs.

