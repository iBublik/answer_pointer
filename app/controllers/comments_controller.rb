class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable
  before_action :set_publish_id

  def create
    @comment = @commentable.comments.build(comments_params.merge(user: current_user))
    if @comment.save
      PrivatePub.publish_to "/questions/#{@publish_id}/comments", comment: @comment.to_json
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_commentable
    @commentable = commentable_name.classify
                   .constantize.find(params["#{commentable_name.singularize}_id".to_sym])
  end

  def set_publish_id
    if @commentable.has_attribute?(:question_id)
      @publish_id = @commentable.question_id
    else
      @publish_id = @commentable.id
    end
  end

  def commentable_name
    params[:commentable]
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
