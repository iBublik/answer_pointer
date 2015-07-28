class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, except: :show

  authorize_resource

  def index
    respond_with @question.answers, each_serializer: BaseBodySerializer
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    respond_with @question.answers.create(answers_params.merge(user: current_user))
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
