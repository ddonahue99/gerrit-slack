class GerritNotifier
  extend Alias

  @@buffer = {}
  @@channel_config = nil
  @@semaphore = Mutex.new

  def self.start!
    @@channel_config = ChannelConfig.new
    start_buffer_daemon
    listen_for_updates
  end

  def self.psa!(msg)
    notify @@channel_config.all_channels, msg
  end

  def self.notify(channels, msg, emoji = '')
    channels.each do |channel|
      slack_channel = "##{channel}"
      add_to_buffer slack_channel, @@channel_config.format_message(channel, msg, emoji)
    end
  end

  def self.notify_user(user, msg)
    channel = "@#{slack_name_for user}"
    add_to_buffer channel, msg
  end

  def self.add_to_buffer(channel, msg)
    @@semaphore.synchronize do
      @@buffer[channel] ||= []
      @@buffer[channel] << msg
    end
  end

  def self.start_buffer_daemon
    # post every X seconds rather than truly in real-time to group messages
    # to conserve slack-log
    Thread.new do
      slack_config = YAML.load(File.read('config/slack.yml'))['slack']

      while true
        @@semaphore.synchronize do
          if @@buffer == {}
            puts "[#{Time.now}] Buffer is empty"
          else
            puts "[#{Time.now}] Current buffer:"
            ap @@buffer
          end

          if @@buffer.size > 0 && !ENV['DEVELOPMENT']
            @@buffer.each do |channel, messages|
              notifier = Slack::Notifier.new slack_config['token']
              notifier.ping(messages.join("\n\n"),
                channel: channel,
                username: 'gerrit',
                icon_emoji: ':gerrit:',
                link_names: 1
              )
            end
          end

          @@buffer = {}
        end

        sleep 15
      end
    end
  end

  def self.listen_for_updates
    stream = YAML.load(File.read('config/gerrit.yml'))['gerrit']['stream']
    puts "Listening to stream via #{stream}"

    IO.popen(stream).each do |line|
      update = Update.new(line)
      process_update(update)
    end

    puts "Connection to Gerrit server failed, trying to reconnect."
    sleep 3
    listen_for_updates
  end

  def self.process_update(update)
    if ENV['DEVELOPMENT']
      ap update.json
      puts update.raw_json
    end

    channels = @@channel_config.channels_to_notify(update.project, update.owner)

    return if channels.size == 0

    # New patchset
    if update.new_patchset? && !update.wip?
      notify channels, "@here, a new patchset has been created: #{update.commit}. Needs *code review*"
    end

    # Jenkins update
    if update.jenkins?
      if update.build_successful? && !update.wip?
        notify channels, "#{update.commit} *passed* Jenkins and is ready for *code review*"
      elsif update.build_failed? && !update.build_aborted?
        notify_user update.owner, "#{update.commit_without_owner} *failed* on Jenkins"
      end
    end

    # Code review +2
    if update.code_review_approved?
      notify channels, "#{update.author_slack_name} has *+2'd* #{update.commit}: the patch is ready to be *submitted*"
    end

    # Code review +1
    if update.code_review_tentatively_approved?
      notify channels, "#{update.author_slack_name} has *+1'd* #{update.commit}"
    end

    # QA/Product
    if update.qa_approved? && update.product_approved?
      notify channels, "#{update.author_slack_name} has *QA/Product-approved* #{update.commit}!", ":mj: :victory:"
    elsif update.qa_approved?
      notify channels, "#{update.author_slack_name} has *QA-approved* #{update.commit}!", ":mj:"
    elsif update.product_approved?
      notify channels, "#{update.author_slack_name} has *Product-approved* #{update.commit}!", ":victory:"
    end

    # Any minuses (Code/Product/QA)
    if update.minus_1ed? || update.minus_2ed?
      verb = update.minus_1ed? ? "-1'd" : "-2'd"
      notify channels, "#{update.author_slack_name} has *#{verb}* #{update.commit}", ":slowclap:"
    end

    # New comment added
    if update.comment_added? && update.human? && update.comment != ''
      notify channels, "#{update.author_slack_name} has left comments on #{update.commit}: \"#{update.comment}\""
    end

    # Merged
    if update.merged?
      notify channels, "#{update.commit} the patch was merged!", ":tada: :aw_yeah:"
    end

    # Patch abandoned
    if update.abandoned?
      notify channels, "The following patchset has been abandoned: #{update.commit}."
    end

  end
end
