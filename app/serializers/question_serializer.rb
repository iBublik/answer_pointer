class QuestionSerializer < BaseBodySerializer
  attributes :title
  has_many :comments
  has_many :attachments
end
