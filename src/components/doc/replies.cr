class Docs::Replies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs doc_path : String
  needs order_by : String
  needs reply_id : Int64?

  def render
    reply_path = doc_path.sub("/docs", "/htmx/docs/replies")

    mount(
      ::Docs::FormButtons,
      page_count: pagination[:count],
      doc_path: doc_path,
      order_by: order_by
    )

    div id: "replies" do
      mount(
        ::Docs::RepliesMore,
        formatter: formatter,
        pagination: pagination,
        page_number: 1,
        current_user: current_user,
        reply_path: reply_path,
        reply_id: reply_id
      )
    end
  end
end
