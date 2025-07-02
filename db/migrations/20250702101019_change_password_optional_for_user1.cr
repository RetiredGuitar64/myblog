class ChangePasswordOptionalForUser1::V20250702101019 < Avram::Migrator::Migration::V1
  def migrate
    make_optional table_for(User), :encrypted_password
  end

  def rollback
    # drop table_for(Thing)
  end
end
