class UpdateUser < User::SaveOperation
  permit_columns name, avatar

  before_save do
    validate_uniqueness_of name
  end

  after_save do |saved_user|
    attributes.select(&.changed?).each do |attribute|
      column_name = attribute.name.to_s
      user_id = saved_user.id

      next if column_name.in? ["updated_at", "created_at"]

      exists_pending_record = UserAuditQuery.new
        .sync_state(UserAudit::SyncStatus::Pending)
        .user_id(user_id)
        .changed_column_name(column_name)

      if exists_pending_record.any?
        exists_pending_record.update(sync_state: UserAudit::SyncStatus::Staled)
      end

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
