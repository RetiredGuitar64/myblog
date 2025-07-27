class AddViewCountToDocs::V20250724164812 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Doc) do
      add view_count : Int32, default: 0
    end
  end

  def rollback
    alter table_for(Doc) do
      remove :view_count
    end
  end
end
