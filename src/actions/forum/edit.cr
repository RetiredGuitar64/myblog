class Forum::Edit < BrowserAction
  get "/forum/:id/edit" do
    topic = TopicQuery.find(id)

    return head 403 if topic.user_id != current_user.id

    html Forum::EditPage, topic: topic, operation: UpdateTopic.new(topic)
  end
end
