class AddSoftDeleteToComments::V20260929120000 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Comment) do
      add soft_deleted_at : Time?
    end

    create_index table_for(Comment), :soft_deleted_at

    remove_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "children_count"
    )
    add_soft_delete_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "children_count",
      target_id_column: "parent_id"
    )

    remove_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "descendants_count"
    )
    add_soft_delete_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "descendants_count",
      target_id_column: "root_id"
    )
  end

  def rollback
    execute <<-SQL
      DO $$ BEGIN
        IF EXISTS (SELECT 1 FROM comments WHERE soft_deleted_at IS NOT NULL) THEN
          RAISE EXCEPTION 'Cannot remove comment soft deletion while deleted comments exist';
        END IF;
      END; $$
      SQL

    remove_soft_delete_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "descendants_count"
    )
    add_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "descendants_count",
      target_id_column: "root_id"
    )

    remove_soft_delete_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "children_count"
    )
    add_counters_for(
      source_table: "comments",
      target_table: "comments",
      target_column: "children_count",
      target_id_column: "parent_id"
    )

    drop_index table_for(Comment), :soft_deleted_at
    alter table_for(Comment) do
      remove :soft_deleted_at
    end
  end
end
