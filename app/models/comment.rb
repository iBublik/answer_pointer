class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable

  validates :body, presence: true, length: { maximum: 150 }
  validates :user_id, :commentable_id, :commentable_type, presence: true
end
