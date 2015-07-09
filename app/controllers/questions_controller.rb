class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]
  before_action :gon_current_user, only: [:index, :show]
  before_action :check_authority, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(questions_params)
    if @question.save
      PrivatePub.publish_to '/questions/index', question: @question.to_json
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    @question.update(questions_params)
  end

  def destroy
    return unless @question.destroy

    redirect_to questions_path, notice: 'Your question was successfully deleted'
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def check_authority
    return if @question.user_id == current_user.id

    render status: :forbidden, text: 'Only author of question can perform this action'
  end

  def gon_current_user
    gon.current_user = user_signed_in? && current_user.id
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
