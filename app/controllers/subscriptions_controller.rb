class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  respond_to :js

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question: @question)
    respond_with @subscription
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
