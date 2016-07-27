require_relative 'reply'
require_relative 'question_database'
require_relative 'question_follow'
require_relative 'user'

class Question
  attr_accessor :title, :body
  attr_reader :id, :author_id

  def self.find_by_id(id)
    id  = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Question.new(id.first)
  end

  def self.find_by_author_id(author_id)
    author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        questions.*
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    author.map {|auth| Question.new(auth)}
  end


  def most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end


  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

end
