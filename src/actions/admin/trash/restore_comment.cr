class Admin::Trash::RestoreComment < AdminAction
  post "/admin/trash/comments/:id/restore" do
    AppDatabase.transaction do
      comment = CommentQuery.new.only_soft_deleted.id(id).for_update.first
      comment.restore
    end

    flash.success = "评论已恢复"

    redirect Admin::Trash::Index
  end
end
