class AddNameIntoUsers::V20250311074653 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add name : String?, unique: true
      add avatar : String?
    end
  end

  def rollback
    alter table_for(User) do
      remove :name
      remove :avatar
    end
  end
end
