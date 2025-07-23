class AddRepliesCounterToReplies::V20250718095246 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Reply) do
      add replies_counter : Int32, default: 0
    end
  end

  def rollback
    alter table_for(Reply) do
      remove :replies_counter
    end
  end
end
