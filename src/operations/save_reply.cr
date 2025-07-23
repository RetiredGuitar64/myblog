class SaveReply < Reply::SaveOperation
  permit_columns user_id, doc_id, reply_id, content
  before_save validate_doc_id_reply_id

  before_save do
    validate_required user_id, content

    user = UserQuery.find(user_id.value.not_nil!)

    user_name.value = user.name

    user.avatar.try do |avatar|
      user_avatar.value = avatar
    end

    if !id.value # 新建的时候
      doc_id.value.try do |doc_id|
        doc = DocQuery.find(doc_id)
        if (last_reply = ReplyQuery.new.doc_id(doc.id).last?)
          floor = last_reply.preferences.floor + 1
        else
          floor = 1
        end

        preferences.value = Reply::Preferences.from_json(
          {
            path_for_doc: doc.path_index,
            floor:        floor,
          }.to_json
        )
      end

      reply_id.value.try do |reply_id|
        reply = ReplyQuery.find(reply_id)
        if (last_reply = ReplyQuery.new.reply_id(reply.id).last?)
          floor = last_reply.preferences.floor + 1
        else
          floor = 1
        end

        preferences.value = Reply::Preferences.from_json(
          {
            path_for_doc: nil,
            floor:        floor,
          }.to_json
        )
      end

      votes.value = Reply::Votes.from_json(
        {
          👍:  0,
          👎:  0,
          😄:  0,
          ❤️: 0,
          🎉:  0,
          😕:  0,
          👀️: 0,
        }.to_json
      )
    end
  end

  private def validate_doc_id_reply_id
    if doc_id.value.blank? && reply_id.value.blank?
      add_error :doc_id_or_reply_id, "必须至少一个存在"
    end
  end
end
