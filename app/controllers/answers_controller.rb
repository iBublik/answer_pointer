class AnswersController < ApplicationController
  include Voting

  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :mark_solution]
  before_action :set_question, only: [:destroy, :update, :mark_solution]
  before_action :find_question, only: :create
  after_action :publish_answer, only: :create

  respond_to :js
  respond_to :json, only: :create

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answers_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    @answer.update(answers_params)
    respond_with @answer
  end

  def mark_solution
    respond_with(@answer.mark_solution)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end

  def publish_answer
    return unless @answer.valid?

    answer = render_to_string partial: 'answer', formats: [:json], locals: { answer: @answer }
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: answer
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
