require_relative 'question'
require_relative 'question_database'
require_relative 'user'

class QuestionLike

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes
      ON
        users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    data.map { |data| User.new(data) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        questions
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        question.id = ?
      SQL
  end

  def self.liked_questions_for_user_id(user_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
          *
        FROM
          questions
        JOIN
          question_likes
        ON
          question.id = question_likes.question_id
        JOIN
          users
        ON
          users.id = question_likes.user_id
        WHERE
          question_likes.user_id = ?
        SQL
      data.map { |data| Question.new(data) }
  end


  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id, n: n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes
      ON
        question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        n
    SQL
    data.map { |data| Question.new(data) }
  end


end
