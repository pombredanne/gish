module Gish
  class Issue
    include TerminalHelpers
    include DateHelpers

    attr_accessor :title, :body

    def initialize(github_issue)
      @url = github_issue.html_url
      @number = github_issue.number.to_s
      @state = github_issue.state
      @title = github_issue.title
      @body = github_issue.body
      @labels = github_issue.labels
      @user = github_issue.user.login
      @comment_count = github_issue.comments.to_s.rjust(3, ' ')
      @assignee = github_issue.assignee.login rescue nil
      @created_at = time_in_words(github_issue.created_at)
      @pull_request = !github_issue.pull_request.rels.keys.empty?
    end

    def headline
      user = @user.ljust(20, ' ')
      title = short_title.ljust(70, ' ')
      number = @number.ljust(5, ' ')
      type = @pull_request ? '[PR]' : '    '
      "##{number}  #{bold(user)}  #{title}  #{bold(type)} #{@comment_count} comments"
    end

    def to_s
      output = underline("##{@number} #{@title}")
      output << " [#{@state}]"
      output << "\nOpened by #{bold(@user)} #{@created_at}"
      output << "\nAssigned to #{bold(@assignee)}" unless @assignee.nil?
      output << "\n\n#{@body}\n\n"
      output << "#{label_names.join(' ')}" unless @labels.empty?
      output
    end

    private

    def short_title
      return "#{@title}" unless @title.length > 60
      "#{@title[0..69]}"
    end

    def label_names
      @labels.map{ |l| format_label(l.name) }
    end
  end
end
