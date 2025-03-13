class Docs::Htmx::Reply < DocAction
  param user_id : Int64
  param doc_id : Int64
  param content : String
  param doc_path : String

  post "/docs/htmx/reply" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id

    SaveReply.create(user_id: user_id, doc_id: doc_id, content: content) do |op, saved_reply|
      if op.saved?
        component(
          Docs::TopicReplies,
          formatter: formatter,
          pagination: replies_pagination(doc_path: doc_path),
          current_user: me,
          doc_path: doc_path,
          order_by: "desc"
        )
      else
        head 400
      end
    end
  end
end
