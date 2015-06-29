module ApplicationHelper
  def belongs_to_current_user?(object)
    user_signed_in? && object.user_id == current_user.id
  end

  def css_style_by_vote(vote, hide_criteria, default_style = [])
    default_style << 'display:none' if vote.present? && vote.value == hide_criteria
    default_style
  end
end
