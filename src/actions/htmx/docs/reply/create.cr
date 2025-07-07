class Htmx::Docs::Reply::Create < DocAction
  param user_id : Int64
  param content : String
  param doc_path : String

  # 回复评论按钮
  post "/htmx/docs/reply" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id
    return head 400 if content.blank?

    doc = DocQuery.new.path_index(doc_path).first

    SaveReply.create(user_id: user_id, doc_id: doc.id, content: content) do |op, _saved_reply|
      if op.saved?
        component(
          ::Docs::FormWithReplies,
          formatter: formatter,
          pagination: replies_pagination(doc_path: doc_path),
          current_user: me,
          doc_path: doc_path,
          order_by: "desc",
          msg: "创建成功"
        )
      else
        head 400
      end
    end
  end
end
