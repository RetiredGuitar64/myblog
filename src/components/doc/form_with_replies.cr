class Docs::FormWithReplies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs doc_path : String
  needs order_by : String

  def render
    mount Docs::ReplyForm, current_user: current_user

    div id: "replies" do
      mount(
        Docs::TopicReplies,
        formatter: formatter,
        pagination: pagination,
        current_user: current_user,
        doc_path: doc_path,
        order_by: order_by
      )
    end
  end
end
