class Docs::Htmx::Reply::Update < DocAction
  param user_id : Int64
  param content : String

  patch "/docs/htmx/reply/:id" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id
    return head 400 if content.blank?

    reply = ReplyQuery.find(id)

    UpdateReply.update!(reply, content: content)
    doc_path = reply.preferences.path_for_doc?.not_nil!

    component(
      Docs::FormWithReplies,
      formatter: formatter,
      pagination: replies_pagination(doc_path: doc_path),
      current_user: me,
      doc_path: doc_path,
      order_by: "desc"
    )
  end
end
