class Admin::Trash::RestoreTopic < AdminAction
  post "/admin/trash/topics/:id/restore" do
    AppDatabase.transaction do
      topic = TopicQuery.new.only_soft_deleted.id(id).for_update.first
      topic.restore
    end

    flash.success = "主题已恢复"

    redirect Admin::Trash::Index.with(kind: "topics")
  end
end
