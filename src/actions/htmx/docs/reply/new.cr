class Htmx::Docs::Reply::New < DocAction
  param doc_path : String?
  param id : Int64?
  param user_id : Int64

  get "/htmx/docs/reply/new" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    if id.nil?
      html_id = "tab"
    else
      html_id = "reply_to_reply"
      reply = ReplyQuery.find(id.not_nil!)
    end

    component(
      ::Docs::ReplyToDocForm,
      current_user: me,
      doc_path: doc_path,
      reply_id: reply.try &.id,
      html_id: html_id
    )
  end
end
