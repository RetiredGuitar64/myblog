class UpdateUser < User::SaveOperation
  permit_columns name, avatar
  attribute password : String
  attribute password_confirmation : String

  before_save do
    validate_uniqueness_of name
    validate_avatar_is_a_link
    if !password.value.nil?
      validate_confirmation_of password, with: password_confirmation
      Authentic.copy_and_encrypt password, to: encrypted_password
    end
  end

  after_save user_audit

  private def validate_avatar_is_a_link
    avatar.value.try do |avatar_value|
      if !avatar_value.starts_with?(%r{http?s://})
        avatar.add_error "必须是一个合法的 http/https 链接"
      end
    end
  end

  private def user_audit(saved_user)
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

      SaveUserAudit.create!(
        user_id: saved_user.id,
        changed_column_name: column_name,
        from: attribute.original_value.to_s,
        to: attribute.value.to_s
      )
    end
  end
end
