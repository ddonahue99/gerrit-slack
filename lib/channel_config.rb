class ChannelConfig
  def initialize
    @config = Channel.all
  end

  def all_channels
    @config.map(&:name)
  end

  def channels_to_notify(project, owner)
    @config.select { |channel, opts|
      opts['project'].include?("#{project}*") ||
      (opts['project'].include?(project) && opts['owner'].include?(owner))
    }.keys
  end

  def format_message(channel, msg, emoji)
    channel = @config[channel] || {}
    if !emoji.empty? && channel.fetch('emoji', true)
      "#{msg} #{emoji}"
    else
      msg
    end
  end
end
