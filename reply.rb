require 'sqlite3'
require_relative 'question_database'
require_relative 'question'
require_relative 'user'

class Reply

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
  end

  def self.find(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Reply.new(data.first)
  end


  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    data.map { |data| Reply.new(data) }
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    data.map { |data| Reply.new(data) }
  end

  def self.find_by_parent_id(parent_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find(@question_id)
  end

  def parent_reply
    Reply.find(@parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_id(@id)
  end
end
