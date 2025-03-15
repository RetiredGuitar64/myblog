class SaveUserAudit < UserAudit::SaveOperation
  permit_columns user_id, changed_column_name, from, to

  before_save do
    validate_required user_id, changed_column_name, from, to
  end
end
