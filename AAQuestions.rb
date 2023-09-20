class Question
  
    def self.find_by_author_id(author_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT *
        FROM questions
        WHERE author_id = ?
      SQL
  
      data.map { |question_data| Question.new(question_data) }
    end
  
    def author
      User.find_by_id(self.author_id)
    end
  
    def replies
      Reply.find_by_question_id(self.id)
    end
  end
  
  class User
  
    def self.find_by_name(fname, lname)
      data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT *
        FROM users
        WHERE fname = ? AND lname = ?
      SQL
  
      return nil unless data.length > 0
  
      User.new(data.first)
    end
  
    def authored_questions
      Question.find_by_author_id(self.id)
    end
  
    def authored_replies
      Reply.find_by_user_id(self.id)
    end
  end
  
  class Reply
  
    def self.find_by_user_id(user_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT *
        FROM replies
        WHERE user_id = ?
      SQL
  
      data.map { |reply_data| Reply.new(reply_data) }
    end
  
    def self.find_by_question_id(question_id)
      data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT *
        FROM replies
        WHERE subject_question_id = ?
      SQL
  
      data.map { |reply_data| Reply.new(reply_data) }
    end
  
    def parent_reply
      return nil if self.parent_reply_id.nil?
  
      Reply.find_by_id(self.parent_reply_id)
    end
  
    def child_replies
      data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
        SELECT *
        FROM replies
        WHERE parent_reply_id = ?
      SQL
  
      data.map { |reply_data| Reply.new(reply_data) }
    end
  
    def author
      User.find_by_id(self.user_id)
    end
  
    def question
      Question.find_by_id(self.subject_question_id)
    end
  end
  