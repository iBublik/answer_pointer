class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { maximum: 150 }
  validates :body, presence: true, length: { maximum: 30_000 }
  validates :user_id, presence: true

  scope :yesterday, -> { where(created_at: Time.current.yesterday.all_day) }

  after_commit :subscribe_author, on: :create

  private

  def subscribe_author
    Subscription.create(question: self, user: user)
  end
end
