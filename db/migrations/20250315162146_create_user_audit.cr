class CreateUserAudit::V20250315162146 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(UserAudit) do
      primary_key id : Int64
      add_timestamps

      add user_id : Int64
      add sync_state : Int32, index: true, default: 1
      add changed_column_name : String
      add from : String
      add to : String
    end
  end

  def rollback
    drop table_for(UserAudit)
  end
end
