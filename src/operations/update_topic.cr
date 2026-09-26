class UpdateTopic < Topic::SaveOperation
  permit_columns node_id, title, content

  before_save do
    validate_required node_id, title, content
    edited_at.value = Time.utc if title.changed? || content.changed?
  end
end
