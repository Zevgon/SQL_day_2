require_relative 'question'
require_relative 'question_database'

class QuestionFollow

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = ['question_id']
  end


  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instnace.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows
      ON
        question_follows.user_id = users.id
      WHERE
        questions.id = ?
    SQL

    data.map { |data| User.new(data) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL
    data.map {|data| Question.new(data)}
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id, n: n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follow
      ON
        question_follows.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        n
    SQL
  end



end
