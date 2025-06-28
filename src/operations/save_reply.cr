class SaveReply < Reply::SaveOperation
  permit_columns user_id, doc_id, content

  before_save do
    validate_required user_id, doc_id, content

    user = UserQuery.find(user_id.value.not_nil!)
    doc = DocQuery.find(doc_id.value.not_nil!)

    user_name.value = user.name

    if id.value
      user.avatar.try do |avatar|
        user_avatar.value = avatar
      end
    else
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
end
