require 'active_support/concern'

module Voting
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :permit_voting, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def vote_cancel
    votable_type = model_name(@votable)

    if @votable.voted_by?(current_user)
      @votable.cancel_vote(current_user)
      render json: {
        rating: @votable.reload.rating,
        type: votable_type,
        id: @votable.id,
        message: 'Your vote has been canceled'
      }
    else
      render json: { error: "You didn't vote for this #{votable_type}" },
             status: :method_not_allowed
    end
  end

  private

  def vote(vote_value)
    action = vote_value == 1 ? 'up' : 'down'
    votable_type = model_name(@votable)

    if @votable.voted_by?(current_user, vote_value)
      render json: { error: "You've already voted #{action} this #{votable_type}" },
             status: :forbidden
    else
      @votable.make_vote(current_user, vote_value)
      render json: {
        rating: @votable.reload.rating,
        type: votable_type,
        id: @votable.id,
        action: action,
        message: 'Your vote has been accepted'
      }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def permit_voting
    return unless @votable.user_id == current_user.id

    render json: { error: "You can't vote for your own #{model_name(@votable)}" },
           status: :forbidden
  end
end
