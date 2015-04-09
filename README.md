# Gerritbot UI
Gerritbot UI uses Rails Admin for the UI, Devise for the authentication, and CanCan for the authorization. Rails Admin can be found here: [https://github.com/sferik/rails_admin]
## RUNNING GERRITBOT
You will have to run
```ruby
bundle exec rake run_notifier
```
from the root directory to enable the Gerrit listener in addition to running this app.
---
## RAILS_ADMIN
There are three user "types": regular users, admin users, and superadmin users.
### Users
Can read and access the dashboard
### Admins
Admins can manage (read and write) Channel and Alias, but not destroy them. You can change this in app/model/ability.rb - look at the CanCan documentation for syntax
### Superadmins
Can manage everything. Because they are super.
---
## DATA INPUT
The "Projects", "Owners", and "Regular Expression" fields are arrays. The emoji fields are text fields.

### ALIASES
If someone has a different username for Slack and Gerrit, enter their respective usernames here.

### CHANNELS
Enter the Channel name without the #, like this:
```
eng
```

### PROJECTS
This field is a serialized array. Enter projects like this:
```
--- [project1*, project2]
```
The asterisk (*), posts **all updates** from the project to the channel. In the example above, any updates from the "project1 project" will post in the channel, but only the owners (below) will receive updates in the "project2 project".

### OWNERS
This field is a serialized array. **Make sure you use their GERRIT username**. Enter owners like this:
```
--- [hannahbot, gerrituser]
```

### REGULAR EXPRESSION
This field is a serialized array. Gerritbot looks at the Gerrit subject, not the commit message, for your regular expression. You do not need to put `/` around your regular expression.

```
[[a|A]11[y|Y], urgent]
```
The above will match
`urgent a11y commit`, `my awesome a11y stuff`, and `urgent ticket` - be careful of putting in whole words!

### EMOJIS
Emojis are text fields. Enter in emojis like this:
```
:tada: :crystal_ball:
```
Currently, the emoji fields don't hide if the checkbox is not checked, but the emoji fields are optional. If you leave them blank, it won't hurt Gerritbot.
