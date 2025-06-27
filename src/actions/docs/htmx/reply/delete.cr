class Docs::Htmx::Reply::Delete < DocAction
  param user_id : Int64
  param reply_id : Int64

  delete "/docs/htmx/reply" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    reply = ReplyQuery.find(reply_id)

    ::DeleteReply.delete!(reply)

    head 200
  end
end
