class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  delegate :attachments, to: :attachable
  alias_method :other_attachments, :attachments

  mount_uploader :file, FileUploader
  validates :file, presence: true
end
