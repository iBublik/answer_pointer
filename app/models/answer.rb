class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  default_scope { order(is_solution: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { maximum: 30_000 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  def mark_solution
    transaction do
      question.answers.update_all(is_solution: false)
      update!(is_solution: true)
    end
  end
end
