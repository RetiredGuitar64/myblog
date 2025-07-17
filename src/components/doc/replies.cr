class Docs::Replies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?, url: String}
  needs order_by : String
  needs reply_id : Int64?

  def render
    div role: "feed", class: "replies" do
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
