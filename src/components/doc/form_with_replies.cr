class Docs::FormWithReplies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs doc_path : String
  needs order_by : String
  needs reply_id : Int64?

  def render
    mount Docs::ReplyToDocForm, current_user: current_user, doc_path: doc_path

    div id: "replies" do
      mount(
        Docs::Replies,
        formatter: formatter,
        pagination: pagination,
        current_user: current_user,
        doc_path: doc_path,
        order_by: order_by,
        reply_id: reply_id
      )
    end
  end
end
