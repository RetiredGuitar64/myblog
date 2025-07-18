class Htmx::Docs::Reply::CreateOrUpdate < DocAction
  param user_id : Int64
  param content : String
  param doc_path : String?
  param id : Int64?
  param op : String?

  # 回复评论按钮
  post "/htmx/docs/reply" do
    me = current_user
    return head 401 if me.nil?
    return head 401 if user_id != me.id
    return head 400 if content.blank?

    if !id.nil?
      reply = ReplyQuery.find(id.not_nil!)

      case op
      when "edit"
        SaveReply.update!(reply, content: content)
        path_for_doc = reply.preferences.path_for_doc?
        if path_for_doc.nil?
          # edit reply to reply
          id_or_doc_path = reply.reply_id.to_s
        else
          # edit reply to doc
          id_or_doc_path = path_for_doc
        end
      when "new"
        # new reply to reply，这个是要回复的那个 reply
        SaveReply.create!(user_id: user_id, reply_id: reply.id, content: content)
        id_or_doc_path = reply.preferences.path_for_doc?.not_nil!
      end
    else
      # 给 doc 新建评论
      doc_path = self.doc_path.not_nil!
      doc = DocQuery.new.path_index(doc_path).first
      SaveReply.create!(user_id: user_id, doc_id: doc.id, content: content)
      id_or_doc_path = doc_path
    end

    pagination = replies_pagination(id_or_doc_path: id_or_doc_path.not_nil!)

    component(
      ::Docs::Replies,
      formatter: formatter,
      pagination: pagination,
      current_user: me,
      order_by: "desc",
      reply_id: reply.try &.id
    )
  end
end
