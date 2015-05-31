class Question < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 150 }
  validates :body, presence: true, length: { maximum: 30_000 }
  has_many :answers, dependent: :destroy
end
