class ChannelConfig

  def all_channels
    Channel.all
  end

  def channels_to_notify
    all_channels.select { |channel|
      channel.projects.include?("#{project}*") ||
      channel.projects.include?(project) && channel.owners.include?(owner)
    }
  end

  def format_message(channel, msg, emoji)
    if !emoji.empty? && channel.emoji_enabled
      "#{msg} #{emoji}"
    else
      msg
    end
  end
end
