class ChannelConfig

  def all_channels
    Channel.all
  end

  def channels_to_notify(project, owner)
    all_channels.select { |channel|
      channel.projects.include?("#{project}*") ||
      channel.projects.include?(project) && channel.owners.include?(owner)
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
