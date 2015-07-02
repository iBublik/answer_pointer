class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment
  before_action :check_authority

  def destroy
    return unless @attachment.attachable.user_id == current_user.id
    @attachment.destroy
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end

  def check_authority
    checked_object = @attachment.attachable
    return if checked_object.user_id == current_user.id

    render status: :forbidden,
           text: "Only author of this #{model_name(checked_object)} can perform this action"
  end
end
