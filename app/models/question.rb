class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 150 }
  validates :body, presence: true, length: { maximum: 30_000 }
end
