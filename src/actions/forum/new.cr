class Forum::New < ForumAction
  get "/forum/new" do
    html Forum::NewPage, operation: SaveTopic.new
  end
end
