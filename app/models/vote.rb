class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, :votable_type, presence: true
  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :votable_id, presence: true, uniqueness: { scope: [:votable_type, :user_id] }

  after_commit :update_votable_rating, on: [:create, :update, :destroy]

  private

  def update_votable_rating
    return unless votable.present?

    if destroyed?
      votable.class.update_counters(votable.id, rating: -value)
    elsif previous_changes.key?(:value)
      votable.class.update_counters(votable.id, rating: value - previous_changes[:value].first)
    end
  end
end
