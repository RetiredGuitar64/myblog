class Docs::FormWithReplies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?, url: String}
  needs doc_path : String
  needs order_by : String
  needs reply_id : Int64?

  def render
    mount Docs::ReplyToDocForm, current_user: current_user, doc_path: doc_path

    mount(
      Docs::Replies,
      formatter: formatter,
      pagination: pagination,
      current_user: current_user,
      order_by: order_by,
      reply_id: reply_id
    )
  end
end
