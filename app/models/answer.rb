class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true, length: { maximum: 30_000 }
  validates :question_id, presence: true
end
