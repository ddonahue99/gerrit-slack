class Update
  include Alias

  attr_reader :raw_json, :json

  def initialize(raw_json)
    @raw_json = raw_json
    @json = JSON.parse(raw_json)
  end

  def type
    json['type']
  end

  def project
    json['change']['project'] if json['change']
  end

  def comment_added?
    type == 'comment-added'
  end

  def merged?
    type == 'change-merged'
  end

  def human?
    !['hudson', 'firework'].include?(json['author']['username'])
  end

  def jenkins?
    comment_added? && json['author']['username'] == 'hudson'
  end

  def build_successful?
    comment =~ /Build Successful/
  end

  def build_failed?
    comment =~ /Build Failed/
  end

  def build_aborted?
    comment =~ /ABORTED/
  end

  def comment
    frd_lines = []
    json['comment'].split("\n\n").each { |line|
      next if line =~ /Patch Set \d+/
      break if line =~ /Reviewer (DID NOT )?check/
      frd_lines << line
    }
    frd_lines.join("\n\n")
  end

  def commit
    "#{commit_without_owner} (by @#{slack_name_for owner})"
  end

  def commit_without_owner
    "<#{json['change']['url']}|[#{json['change']['project']}] #{sanitized_subject}>"
  end

  def owner
    if json['change']
      json['change']['owner']['username']
    elsif json['submitter']
      json['submitter']['username']
    end
  end

  def sanitized_subject
    sanitized = subject
    sanitized.gsub!('<', '&lt;')
    sanitized.gsub!('>', '&gt;')
    sanitized.gsub!('&', '&amp;')
    sanitized
  end

  def subject
    json['change']['subject']
  end

  def wip?
    !!(subject.match /\bwip\b/i)
  end

  def author
    json['author']['username']
  end

  def author_slack_name
    slack_name_for author
  end

  def approvals
    json['approvals']
  end

  def code_review_approved?
    has_approval?('Code-Review', '2')
  end

  def code_review_tentatively_approved?
    has_approval?('Code-Review', '1')
  end

  def code_review_rejected?
    has_approval?('Code-Review', '-1')
  end

  def qa_approved?
    has_approval?('QA-Review', '1')
  end

  def qa_rejected?
    has_approval?('QA-Review', '-1')
  end

  def product_approved?
    has_approval?('Product-Review', '1')
  end

  def product_rejected?
    has_approval?('Product-Review', '-1')
  end

  def minus_1ed?
    qa_rejected? || product_rejected? || code_review_rejected?
  end

  def minus_2ed?
    has_approval?('Code-Review', '-2')
  end

  def has_approval?(type, value)
    approvals && \
      approvals.find { |approval| approval['type'] == type && approval['value'] == value }
  end
end
