class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]

  def create
    @answer = @question.answers.build(answers_params.merge(user: current_user))
    if @answer.save
      flash.notice = 'Your answer successfully added'
    else
      flash.notice = 'Something goes wrong. Please try to resubmit your answer'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    if answer.user_id == current_user.id
      answer.destroy
      redirect_to question_path(answer.question), notice: 'Your answer was successfully deleted'
    else
      redirect_to question_path(answer.question)
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
