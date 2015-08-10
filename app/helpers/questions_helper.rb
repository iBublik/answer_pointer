module QuestionsHelper
  def subscribed?
    user_signed_in? && current_user.subscribed_to?(@question || question)
  end
end
