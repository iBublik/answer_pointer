class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  default_scope { order(is_solution: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { maximum: 30_000 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  after_commit :notify_subscribers, on: :create

  def mark_solution
    transaction do
      question.answers.update_all(is_solution: false)
      update!(is_solution: true)
    end
  end

  private

  def notify_subscribers
    AnswerNotificationsJob.perform_later(self)
  end
end
