require 'spec_helper'

describe 'Update' do
  describe 'initialize' do
    it 'parses the passed in JSON' do
      json = File.read('spec/fixtures/comment-added.json')
      update = Update.new(json)
      update.type.should == 'comment-added'
    end
  end

  describe "code_review_approved?" do
    it "returns true when +2 Code-Review" do
      json = File.read('spec/fixtures/code-review-approved.json')
      update = Update.new(json)
      expect(update.code_review_approved?).to be_true
    end

    it "returns false when not +2 Code-Review" do
      json = File.read('spec/fixtures/code-review-tentatively-approved.json')
      update = Update.new(json)
      expect(update.code_review_approved?).to be_false
    end
  end

  describe "code_review_tentatively_approved?" do
    it "returns true when +1 Code-Review" do
      json = File.read('spec/fixtures/code-review-tentatively-approved.json')
      update = Update.new(json)
      expect(update.code_review_tentatively_approved?).to be_true
    end

    it "returns false when not +1 Code-Review" do
      json = File.read('spec/fixtures/code-review-approved.json')
      update = Update.new(json)
      expect(update.code_review_tentatively_approved?).to be_false
    end
  end

  describe "code_review_rejected?" do
    it "is true when Code-Review -1 or -2" do
      json = File.read('spec/fixtures/code-review-rejected.json')
      update = Update.new(json)
      expect(update.code_review_rejected?).to be_true
    end

    it "is false when not Code-Review -1 or 2" do
      json = File.read('spec/fixtures/code-review-approved.json')
      update = Update.new(json)
      expect(update.code_review_rejected?).to be_false
    end
  end

  describe "merged?" do
    it "is true when type is change-merged" do
      json = File.read('spec/fixtures/merged.json')
      update = Update.new(json)
      expect(update.merged?).to be_true
    end

    it "is false when a reviewer was not added" do
      json = File.read('spec/fixtures/comment-added.json')
      update = Update.new(json)
      expect(update.merged?).to be_false
    end
  end

  describe "comment" do
    it "returns only the portion of the comment that the user typed" do
      json = File.read('spec/fixtures/comment-added.json')
      update = Update.new(json)
      expect(update.comment).to eq("test cover message")
    end
  end

  describe "channels" do
    let(:config) { YAML.load(File.read('spec/fixtures/config/channels.yml')) }
    let(:update) { Update.new("{}") }

    context "when the project has an asterisk" do
      it "is always included no matter who the owner is" do
        update.stub(:project).and_return('game-of-thrones')
        update.stub(:owner).and_return('willsmith')
        update.channels(config).should == ['hbo']
      end
    end

    context "when the project does not have an asterisk" do
      it "is included only if there is an owner match" do
        update.stub(:project).and_return('canvas-lms')
        update.stub(:owner).and_return('panda')
        update.channels(config).should == ['canvas']
      end

      it "is not included on an owner mismatch" do
        update.stub(:project).and_return('canvas-lms')
        update.stub(:owner).and_return('notpanda')
        update.channels(config).should == []
      end
    end

    context "when the project is not listed" do
      it "is not included" do
        update.stub(:project).and_return('not-canvas')
        update.channels(config).should == []
      end
    end
  end

  describe "wip?" do
    let(:update) { Update.new("{}") }

    it "correctly identifies wips" do
      {
        "wip: it's a wip" => true,
        "wipe it clean" => false,
        "WIP doin stuff" => true
      }.each do |subject, expected|
        update.stub(:subject).and_return(subject)
        update.wip?.should == expected
      end
    end
  end
end
