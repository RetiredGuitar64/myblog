class Htmx::Comments::Delete < CommentAction
  delete "/htmx/comments/:id" do
    me = current_user
    return head 401 if me.nil?

    status = 200
    refresh_page = false

    AppDatabase.transaction do
      comment = CommentQuery.new.id(id).for_update.first

      next status = 403 unless comment.user_id == me.id || me.admin?
      next status = 409 if comment.children_count > 0 && !me.admin?

      refresh_page = comment.children_count > 0
      DeleteComment.delete!(comment)
    end

    context.response.headers["HX-Refresh"] = "true" if status == 200 && refresh_page

    head status
  end
end
