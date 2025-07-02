class ChangePasswordOptionalForUser::V20250702091600 < Avram::Migrator::Migration::V1
  def migrate
    make_optional table_for(User), :encrypted_password
  end
end
