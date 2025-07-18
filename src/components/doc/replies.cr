class Docs::Replies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?, url: String}
  needs order_by : String
  needs reply_id : Int64?

  def render
    opts = {
      role: "feed",
    }

    if reply_id
      opts = opts.merge(id: "doc_reply-#{reply_id}-replies")
    else
      opts = opts.merge(id: "replies")
    end

    div opts do
      mount(
        ::Docs::FormButtons,
        page_count: pagination[:count],
        reply_path: pagination[:url],
        order_by: order_by
      )

      mount(
        ::Docs::RepliesMore,
        formatter: formatter,
        pagination: pagination,
        page_number: 1,
        current_user: current_user,
        reply_id: reply_id
      )
    end
  end
end
