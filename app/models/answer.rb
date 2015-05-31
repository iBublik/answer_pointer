class Answer < ActiveRecord::Base
  validates :body, presence: true, length: { maximum: 30_000 }
  belongs_to :question
end
