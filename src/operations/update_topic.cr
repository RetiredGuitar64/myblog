class UpdateTopic < Topic::SaveOperation
  permit_columns title, content

  before_save do
    validate_required title, content
    edited_at.value = Time.utc if title.changed? || content.changed?
  end
end
