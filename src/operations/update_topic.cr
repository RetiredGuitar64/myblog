class UpdateTopic < Topic::SaveOperation
  permit_columns title, content

  before_save do
    validate_required title, content
  end
end
