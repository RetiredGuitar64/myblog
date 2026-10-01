class Admin::Trash::RestoreComment < AdminAction
  post "/admin/trash/comments/:id/restore" do
    message = "评论已恢复"

    AppDatabase.transaction do
      comment = CommentQuery.new.only_soft_deleted.id(id).for_update.first
      comment.restore

      if !CommentThreadQuery.find(comment.comment_thread_id).target_visible?
        message = "评论已恢复，但所属主题仍被删除，暂时不可见"
      elsif (root_id = comment.root_id) && CommentQuery.new.id(root_id).none?
        message = "评论已恢复，但根评论仍被删除，暂时不可见"
      end
    end

    flash.success = message

    redirect Admin::Trash::Index
  end
end
