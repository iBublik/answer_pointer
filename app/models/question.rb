class Question < ActiveRecord::Base
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { maximum: 150 }
  validates :body, presence: true, length: { maximum: 30_000 }
  validates :user_id, presence: true
end
