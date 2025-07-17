class Htmx::Docs::Reply::New < DocAction
  param user_id : Int64
  param doc_path : String?
  param id : Int64?

  get "/htmx/docs/reply/new" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    # 根据 doc_path 是否存在，判断这是针对 doc 的回复还是针对评论的回复
    if doc_path.nil?
      # 回复 reply 的 reply
      html_id = "reply_to_reply"
      reply = ReplyQuery.find(id.not_nil!)
    else
      # 回复 doc 的 reply
      html_id = "tab"
    end

    send_text_response("<h1>Hello world</h1>", "text/html")

    component(
      ::Docs::ReplyToDocForm,
      current_user: me,
      doc_path: doc_path,
      reply_id: reply.try &.id,
      html_id: html_id
    )
  end
end
