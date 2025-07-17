class Htmx::Docs::Reply::CreateOrUpdate < DocAction
  param user_id : Int64
  param content : String
  param doc_path : String?
  param id : Int64?
  param reply_id : Int64?
  param op : String?

  # 回复评论按钮
  post "/htmx/docs/reply" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id
    return head 400 if content.blank?

    if !id.nil?
      reply = ReplyQuery.find(id.not_nil!)
      pagination = replies_pagination(id_or_doc_path: reply.preferences.path_for_doc?.not_nil!)

      case op
      when "edit"
        SaveReply.update!(reply, content: content)
      when "new"
        # pagination = replies_pagination(id_or_doc_path: reply.id.to_s)
        SaveReply.create!(user_id: user_id, reply_id: reply.id, content: content)
      end
    else
      # 给 doc 新建评论
      doc = DocQuery.new.path_index(doc_path.not_nil!).first
      pagination = replies_pagination(id_or_doc_path: doc_path.not_nil!)

      SaveReply.create!(user_id: user_id, doc_id: doc.id, content: content)
    end

    component(
      ::Docs::Replies,
      formatter: formatter,
      pagination: pagination.not_nil!,
      current_user: me,
      order_by: "desc",
      reply_id: reply.try(&.id)
    )
  end
end
