class AddDocSearchContent::V20260928120100 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Doc) do
      add content : String?
    end

    execute "CREATE INDEX docs_content_pgroonga_index ON docs USING pgroonga (content)"
  end

  def rollback
    execute "DROP INDEX docs_content_pgroonga_index"

    alter table_for(Doc) do
      remove :content
    end
  end
end
