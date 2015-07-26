class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]
  before_action :gon_current_user, only: [:index, :show]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @answer
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def publish_question
    PrivatePub.publish_to '/questions/index', question: @question.to_json if @question.valid?
  end

  def gon_current_user
    gon.current_user = user_signed_in? && current_user.id
  end

  def build_answer
    @answer = @question.answers.build
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
