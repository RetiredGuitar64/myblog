class AddBelongsToReplyForReplies::V20250716093250 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Reply) do
      add_belongs_to reply : Reply?, on_delete: :cascade
      add belongs_to_counter : Int32, default: 0
    end
  end

  def rollback
    alter table_for(Reply) do
      remove_belongs_to :reply
      remove :belongs_to_counter
    end
  end
end
