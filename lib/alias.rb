module Alias
  def slack_name_for(user)
    @@aliases ||= YAML.load(File.read('config/aliases.yml'))['aliases']
    @@aliases[user] || user
  end
end
