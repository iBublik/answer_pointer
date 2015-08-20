module ApplicationHelper
  def belongs_to_current_user?(object)
    user_signed_in? && object.user_id == current_user.id
  end

  def css_style_by_vote(vote, hide_criteria, default_style = [])
    default_style << 'display:none' if vote.present? && vote.value == hide_criteria
    default_style
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def cache_key_for_user(model, description)
    user_id = user_signed_in? ? current_user.id : 0
    "#{model.to_s.pluralize}/#{description}-#{model.id}-for-user-#{user_id}"
  end
end
