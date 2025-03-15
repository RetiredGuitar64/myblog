class UpdateUser < User::SaveOperation
  permit_columns name, avatar

  before_save do
    validate_uniqueness_of name
  end

  after_save do |saved_user|
    attributes.select(&.changed?).each do |attribute|
      column_name = attribute.name.to_s

      next if column_name.in? ["updated_at", "created_at"]

      SaveUserAudit.create(
        user_id: saved_user.id,
        changed_column_name: column_name,
        from: attribute.original_value.to_s,
        to: attribute.value.to_s
      ) do |op, record|
      end
    end
  end
end
