class Htmx::Docs::Reply::Update < DocAction
  param user_id : Int64
  param content : String

  patch "/htmx/docs/reply/:id" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id
    return head 400 if content.blank?

    reply = ReplyQuery.find(id)

    UpdateReply.update!(reply, content: content)
    doc_path = reply.preferences.path_for_doc?

    if doc_path.nil?
      id_or_doc_path = reply.id.to_s
    else
      id_or_doc_path = doc_path
    end

    component(
      ::Docs::Replies,
      formatter: formatter,
      pagination: replies_pagination(id_or_doc_path: id_or_doc_path),
      current_user: me,
      order_by: "desc",
      reply_id: id.to_i64
    )
  end
end
