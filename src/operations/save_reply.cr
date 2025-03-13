class SaveReply < Reply::SaveOperation
  permit_columns user_id, doc_id, content

  before_save do
    user = UserQuery.find(user_id.value.not_nil!)
    doc = DocQuery.find(doc_id.value.not_nil!)

    if id.value
      user.avatar.try do |avatar|
        if (prefs = preferences.value)
          prefs.user_avatar = avatar
        end
      end
    else
      preferences.value = Reply::Preferences.from_json(
        {
          user_name:    user.name,
          posted_at:    Time.local,
          path_for_doc: doc.path_index,
          user_avtar:   user.avatar,
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
