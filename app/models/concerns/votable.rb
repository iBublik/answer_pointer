require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :delete_all, as: :votable
  end

  def make_vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.update(value: value)
  end

  def voted_by?(user, value = [-1, 1])
    votes.where(user: user, value: value).any?
  end

  def cancel_vote(user)
    vote = user_vote(user)
    vote.destroy if vote.present?
  end

  def user_vote(user)
    votes.find_by(user: user)
  end
end
