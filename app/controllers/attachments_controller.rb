class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  authorize_resource

  def destroy
    return unless @attachment.attachable.user_id == current_user.id
    @attachment.destroy
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
