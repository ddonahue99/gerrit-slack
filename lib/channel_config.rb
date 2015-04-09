class ChannelConfig

  def all_channels
    Channel.all
  end

  def channels_to_notify(update)
    all_channels.select { |channel|

      #channels with asterisk'd projects with regexes
      channel.projects.include?("#{update.project}*") && channel.regexes.any?{|regex| update.regex_matches?(regex)} ||

      #channels with asterisk'd projects without regexes
      channel.projects.include?("#{update.project}*") && !channel.regexes.any? ||

      # channels with specified projects with owners and regexes
      channel.projects.include?(update.project) && channel.owners.include?(update.owner) && channel.regexes.any?{|regex| update.regex_matches?(regex)} ||

      # channels with specified projects with owners and no regexes
      channel.projects.include?(update.project) && channel.owners.include?(update.owner) && !channel.regexes.any? ||

      # channels with regex without projects and with owners
      !channel.projects.any? && channel.regexes.any?{|regex| update.regex_matches?(regex)} && channel.owners.include?(update.owner) ||

      # channels with regex only
      !channel.projects.any? && !channel.owners.any? && channel.regexes.any?{|regex| update.regex_matches?(regex)}
    }.map(&:name)
  end

  def format_message(channel, msg, emoji)
    channel_config = Channel.find_by_name(channel)
    if !emoji.empty? && channel_config.emoji_enabled
      "#{msg} #{emoji}"
    else
      msg
    end
  end
end
