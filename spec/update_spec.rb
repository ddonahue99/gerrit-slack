require 'spec_helper'

RSpec.describe Update do
  describe 'initialize' do
    it 'parses the passed in JSON' do
      json = File.read('spec/fixtures/comment-added.json')
      update = Update.new(json)
      update.type.should == 'comment-added'
    end
  end

  describe "matches regex?" do
    it "returns true for regex" do
      json = File.read('spec/fixtures/code-review-approved.json')
      update = Update.new(json)
      expect(update.regex_matches?(/test/)).to be_truthy
    end
  end

  describe "code_review_approved?" do
    it "returns true when +2 Code-Review" do
      json = File.read('spec/fixtures/code-review-approved.json')
      update = Update.new(json)
      expect(update.code_review_approved?).to be_truthy
    end

    it "returns false when not +2 Code-Review" do
      json = File.read('spec/fixtures/code-review-tentatively-approved.json')
      update = Update.new(json)
      expect(update.code_review_approved?).to be_falsey
    end
  end

  describe "code_review_tentatively_approved?" do
    it "returns true when +1 Code-Review" do
      json = File.read('spec/fixtures/code-review-tentatively-approved.json')
      update = Update.new(json)
      expect(update.code_review_tentatively_approved?).to be_truthy
    end

    it "returns false when not +1 Code-Review" do
      json = File.read('spec/fixtures/code-review-approved.json')
      update = Update.new(json)
      expect(update.code_review_tentatively_approved?).to be_falsey
    end
  end

  describe "code_review_rejected?" do
    it "is true when Code-Review -1 or -2" do
      json = File.read('spec/fixtures/code-review-rejected.json')  # -1
      update = Update.new(json)
      expect(update.code_review_rejected?).to be_truthy
      expect(update.minus_1ed?).to be_truthy
      expect(update.minus_2ed?).to be_falsey
    end

    it "is false when not Code-Review -1 or -2" do
      json = File.read('spec/fixtures/code-review-approved.json')
      update = Update.new(json)
      expect(update.code_review_rejected?).to be_falsey
      expect(update.minus_1ed?).to be_falsey
      expect(update.minus_2ed?).to be_falsey
    end
  end

  describe "merged?" do
    it "is true when type is change-merged" do
      json = File.read('spec/fixtures/merged.json')
      update = Update.new(json)
      expect(update.merged?).to be_truthy
    end

    it "is false when type is not change-merged" do
      json = File.read('spec/fixtures/comment-added.json')
      update = Update.new(json)
      expect(update.merged?).to be_falsey
    end
  end

  describe "build_aborted?" do
    it "is true when comment contains ABORTED" do
      json = File.read('spec/fixtures/jenkins-aborted.json')
      update = Update.new(json)
      expect(update.build_aborted?).to be_truthy
    end

    it "is false when not aborted" do
      json = File.read('spec/fixtures/comment-added.json')
      update = Update.new(json)
      expect(update.build_aborted?).to be_falsey
    end
  end

  describe "comment" do
    it "returns only the portion of the comment that the user typed" do
      json = File.read('spec/fixtures/comment-added.json')
      update = Update.new(json)
      expect(update.comment).to eq("test cover message")
    end
  end

  describe "wip?" do
    let(:update) { Update.new("{}") }

    it "correctly identifies wips" do
      {
        "wip: it's a wip" => true,
        "wipe it clean" => false,
        "WIP doin stuff" => true,
        "[wip] lol" => true
      }.each do |subject, expected|
        update.stub(:subject).and_return(subject)
        update.wip?.should == expected
      end
    end
  end
end
