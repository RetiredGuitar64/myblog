class AddEditedAtToTopics::V20260925120000 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Topic) do
      # 仅在标题或正文实际改变时写入，用于区分内容编辑和其他数据库更新。
      add edited_at : Time?
    end
  end

  def rollback
    alter table_for(Topic) do
      remove :edited_at
    end
  end
end
