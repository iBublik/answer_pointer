class QuestionInCollectionSerializer < BaseBodySerializer
  attributes :title, :short_title
  has_many :answers

  def short_title
    object.title.truncate(10)
  end
end
