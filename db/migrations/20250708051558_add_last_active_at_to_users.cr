class AddLastActiveAtToUsers::V20250708051558 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add last_active_at : Time?, index: true
    end
  end

  def rollback
    alter table_for(User) do
      remove :last_active_at
    end
  end
end
