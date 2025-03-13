class CreateDocs::V20250309141337 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Doc) do
      primary_key id : Int64
      add path_index : String, unique: true, index: true
      add_timestamps
    end
  end

  def rollback
    drop table_for(Doc)
  end
end
