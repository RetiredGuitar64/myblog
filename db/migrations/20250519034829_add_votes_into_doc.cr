class AddVotesIntoDoc::V20250519034829 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Doc) do
      add votes : JSON::Any, fill_existing_with: {"👍" => 0, "👎" => 0, "❤️" => 0}
    end
  end

  def rollback
    alter table_for(User) do
      remove :votes
    end
  end
end
