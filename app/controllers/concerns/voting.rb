require 'active_support/concern'

module Voting
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :permit_voting, only: [:vote_up, :vote_down, :vote_cancel]
    respond_to :json, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    vote 1
  end

  def vote_down
    vote(-1)
  end

  def vote_cancel
    if @votable.voted_by?(current_user)
      respond_with(@votable.cancel_vote(current_user)) do |format|
        format.json { render_response }
      end
    else
      render json: { error: "You didn't vote for this #{model_name(@votable)}" },
             status: :method_not_allowed
    end
  end

  private

  def vote(vote_value)
    if @votable.voted_by?(current_user, vote_value)
      render json: { error: "You've already voted #{vote_action} this #{model_name(@votable)}" },
             status: :forbidden
    else
      respond_with(@votable.make_vote(current_user, vote_value)) do |format|
        format.json { render_response }
      end
    end
  end

  def vote_action
    action_name.sub(/^vote_/, '')
  end

  def render_response
    render partial: 'shared/vote',
           locals: { action: vote_action, message: t('.message'), type: model_name(@votable) }
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
