class Forum::Update < BrowserAction
  param content : String = ""

  put "/forum/:id" do
    topic = TopicQuery.find(id)
    
    return head 403 if topic.user_id != current_user.id

    UpdateTopic.update(topic, params, content: content) do |operation, _updated_topic|
      if operation.saved?
        flash.success = "主题已更新"
        
        redirect Forum::Show.with(id: topic.id)
      else
        build_failed_flash(operation)
        
        html Forum::EditPage, topic: topic, operation: operation
      end
    end
  end
end
