class Docs::Htmx::Reply::Edit < DocAction
  param user_id : Int64

  get "/docs/htmx/reply/:id" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    reply = ReplyQuery.find(id)

    component(
      Docs::Form,
      current_user: current_user,
      content: reply.content,
      reply_id: id.to_i64
    )
  end
end
