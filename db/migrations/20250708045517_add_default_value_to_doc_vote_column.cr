class AddDefaultValueToDocVoteColumn::V20250708045517 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Doc) do
      change_default votes : JSON::Any, default: JSON.parse({"👍" => 0, "👎" => 0, "❤️" => 0}.to_json)
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
