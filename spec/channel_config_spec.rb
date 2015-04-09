require 'spec_helper'

RSpec.describe ChannelConfig do

  let(:config) { ChannelConfig.new }
  let!(:channel_1) { Channel.create!(name: 'asterisk', projects: ['projecta*']) }
  let!(:channel_2) { Channel.create!(name: 'no-asterisk', projects: ['projectb'], owners: ['person'], emoji_enabled: false) }
  let!(:channel_3) { Channel.create!(name: 'no-regex-has-project', projects: ['projectc'], owners: ['persona'], regexes: []) }
  let!(:channel_4) { Channel.create!(name: 'no-project-has-regex', projects: [], owners: ['personc'], regexes: ['test', 'accessibility']) }
  let!(:channel_5) { Channel.create!(name: 'regex-and-project', projects: ['projectd'], owners: ['persond'], regexes:['[a|A]11[y|Y]']) }
  let!(:channel_6) { Channel.create!(name: 'regex-only', regexes:['lulz']) }

  describe "#channels_to_notify" do
    context "when the project has an asterisk" do
      it "is always included no matter who the owner is" do
        json = File.read('spec/fixtures/channel-config-asterisk.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == ['asterisk']
      end
    end

    context "when the project does not have an asterisk" do
      it "is included only if there is an owner match" do
        json = File.read('spec/fixtures/channel-config-no-asterisk.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == ['no-asterisk']
      end

      it "is not included on an owner mismatch" do
        json = File.read('spec/fixtures/channel-config-no-owner.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == []
      end
    end

    context "when the regex is listed and the project is not listed" do
      it "is included" do
        json = File.read('spec/fixtures/channel-config-no-project-regex.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == ['no-project-has-regex']
      end
    end

    context "when the regex is not listed and the project is listed" do
      it "is is included" do
        json = File.read('spec/fixtures/channel-config-no-regex.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == ['no-regex-has-project']
      end
    end

    context "when the regex is listed and the project is listed" do
      it "is included" do
        json = File.read('spec/fixtures/channel-config-regex-project.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == ['regex-and-project']
      end
    end

    context "when the regex is not listed and the project is not listed" do
      it "is not included" do
        json = File.read('spec/fixtures/channel-config-no-project.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == []
      end
    end

    context "when only the regex is listed" do
      it "is included" do
        json = File.read('spec/fixtures/channel-config-regex-only.json')
        update = Update.new(json)
        config.channels_to_notify(update).should == ['regex-only']
      end
    end

  end

  describe '#format_message' do
    it "includes emojis for configured channel by default" do
      config.format_message('asterisk', 'msg', 'emoji').should == 'msg emoji'
    end

    it "excludes emoji if channel turns them off" do
      config.format_message('no-asterisk', 'msg', 'emoji').should == 'msg'
    end

    it "strips trailing spaces if emoji string is empty" do
      config.format_message('asterisk', 'msg', '').should == 'msg'
    end
  end
end
