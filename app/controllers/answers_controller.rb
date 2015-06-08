class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]

  def new
    @answer = Answer.new(question_id: @question.id)
  end

  def create
    @answer = @question.answers.new(answers_params.merge(user: current_user))
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully added'
    else
      render :new
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
