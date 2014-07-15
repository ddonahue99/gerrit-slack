require 'spec_helper'

describe ChannelConfig do
  let(:config) { ChannelConfig.new('spec/fixtures/config/channels.yml') }

  describe "#channels_to_notify" do
    context "when the project has an asterisk" do
      it "is always included no matter who the owner is" do
        config.channels_to_notify('game-of-thrones', 'willsmith').should == ['hbo']
      end
    end

    context "when the project does not have an asterisk" do
      it "is included only if there is an owner match" do
        config.channels_to_notify('canvas-lms', 'panda').should == ['canvas']
      end

      it "is not included on an owner mismatch" do
        config.channels_to_notify('canvas-lms', 'notpanda').should == []
      end
    end

    context "when the project is not listed" do
      it "is not included" do
        config.channels_to_notify('not-canvas', 'panda').should == []
      end
    end
  end

  describe '#format_message' do
    it "includes emojis for configured channel by default" do
      config.format_message('hbo', 'msg', 'emoji').should == 'msg emoji'
    end

    it "include emojis for random channels by default" do
      config.format_message('anything', 'msg', 'emoji').should == 'msg emoji'
    end

    it "excludes emoji if channel turns them off" do
      config.format_message('no-emojis', 'msg', 'emoji').should == 'msg'
    end

    it "strips trailing spaces if emoji string is empty" do
      config.format_message('hbo', 'msg', '').should == 'msg'
    end
  end
end
