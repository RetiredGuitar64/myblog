class Admin::Index < AdminAction
  get "/admin" do
    recent_topics = TopicQuery.new.created_at.desc_order.limit(6).preload_user.preload_node.results

    html(
      Admin::IndexPage,
      users_count: UserQuery.new.select_count,
      docs_count: DocQuery.new.select_count,
      topics_count: TopicQuery.new.select_count,
      comments_count: CommentQuery.new.select_count,
      nodes_count: NodeQuery.new.select_count,
      recent_topics: recent_topics
    )
  end
end
