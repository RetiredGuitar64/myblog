class UpdateUser < User::SaveOperation
  permit_columns name, avatar

  before_save do
    validate_uniqueness_of name
  end
end
