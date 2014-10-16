class ChannelConfig
  def initialize
    @channel = Channel.all
  end

  def all_channels
    @channels
  end

  def channels_to_notify
    @channels.select { |channel|
      channel.projects.include?("#{project}*") ||
      channel.projects.include?(project) && channel.owners.include?(owner)
    }.map(&:name)
  end

  def format_message(channel, msg, emoji)
    if !emoji.empty? && channel.emoji_enabled
      "#{msg} #{emoji}"
    else
      msg
    end
  end
end
