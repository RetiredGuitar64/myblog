class Htmx::Docs::Reply::Delete < DocAction
  param user_id : Int64

  delete "/htmx/docs/reply/:id" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    reply = ReplyQuery.find(id)

    ::DeleteReply.delete!(reply)

    head 200
  end
end
