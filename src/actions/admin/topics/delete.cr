class Admin::Topics::Delete < AdminAction
  delete "/admin/topics/:id" do
    topic = TopicQuery.find(id)

    DeleteTopic.delete!(topic)
    flash.success = "主题已删除"

    if context.request.headers["HX-Request"]?
      context.response.headers["HX-Redirect"] = Forum::Index.path
      head 200
    else
      redirect Forum::Index
    end
  end
end
