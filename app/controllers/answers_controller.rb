class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, except: [:create]
  before_action :set_question, except: [:create]
  before_action :find_question, only: [:create]

  def create
    @answer = @question.answers.build(answers_params.merge(user: current_user))
    if @answer.save
      flash.notice = 'Your answer successfully added'
    else
      flash.notice = 'Something goes wrong. Please try to resubmit your answer'
    end
  end

  def destroy
    return unless @answer.user_id == current_user.id
    flash.notice = 'Your answer was successfully deleted' if @answer.destroy
  end

  def update
    @answer.update(answers_params) if @answer.user_id == current_user.id
  end

  def mark_solution
    return if @question.user_id != current_user.id
    @answer.mark_solution
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

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
