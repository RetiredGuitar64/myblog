class Htmx::Docs::Reply::New < DocAction
  param doc_path : String
  param user_id : Int64

  get "/htmx/docs/reply/new/?:id" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    reply = ReplyQuery.find(id.not_nil!) if !id.nil?

    component(
      ::Docs::ReplyToDocForm,
      current_user: me,
      doc_path: doc_path,
      reply_id: reply.try &.id
    )
  end
end
