class AnswersController < ApplicationController
  include Voting

  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :mark_solution]
  before_action :set_question, only: [:destroy, :update, :mark_solution]
  before_action :find_question, only: [:create]
  before_action :check_authority, only: [:destroy, :update, :mark_solution]

  def create
    @answer = @question.answers.build(answers_params.merge(user: current_user))
    if @answer.save
      # Don't know how to nest attachments into answer
      PrivatePub.publish_to "/questions/#{@question.id}/answers",
                            response: {
                              answer: @answer,
                              attachments: @answer.attachments,
                              answers_count: @question.answers.count
                            }.to_json
      render json: {
        answer: @answer,
        attachments: @answer.attachments,
        answers_count: @question.answers.count
      }
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    flash.notice = 'Your answer was successfully deleted' if @answer.destroy
  end

  def update
    @answer.update(answers_params)
  end

  def mark_solution
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

  def check_authority
    checked_object = action_name == 'mark_solution' ? @question : @answer

    return if checked_object.user_id == current_user.id

    render status: :forbidden,
           text: "Only author of this #{model_name(checked_object)} can perform this action"
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
