class AnswerSerializer < BaseBodySerializer
  has_many :comments
  has_many :attachments
end
