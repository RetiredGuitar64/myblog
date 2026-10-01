class AddSoftDeleteToTopics::V20260929121000 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Topic) do
      add soft_deleted_at : Time?
    end

    create_index table_for(Topic), :soft_deleted_at
  end

  def rollback
    execute <<-SQL
      DO $$ BEGIN
        IF EXISTS (SELECT 1 FROM topics WHERE soft_deleted_at IS NOT NULL) THEN
          RAISE EXCEPTION 'Cannot remove topic soft deletion while deleted topics exist';
        END IF;
      END; $$
      SQL

    drop_index table_for(Topic), :soft_deleted_at
    alter table_for(Topic) do
      remove :soft_deleted_at
    end
  end
end
