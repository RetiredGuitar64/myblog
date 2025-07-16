class AddBelongsToReplyForReplies::V20250716093250 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Reply) do
      add_belongs_to reply : Reply?, on_delete: :cascade
    end
  end

  def rollback
    alter table_for(Reply) do
      remove_belongs_to :reply
    end
  end
end
