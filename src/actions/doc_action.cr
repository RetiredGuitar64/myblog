abstract class DocAction < BrowserAction
  include Lucky::Paginator::BackendHelpers
  include Auth::AllowGuests
  include PageHelpers

  expose formatter

  def replies_pagination(doc_path : String? = nil, id : Int64? = nil, order_by = "desc")
    return {count: 0, replies: ReplyQuery.new.none, page: nil} unless order_by.in?("desc", "asc")

    if id.nil?
      current_doc = DocQuery.new.path_index(doc_path.not_nil!).first
      q = ReplyQuery.new.doc_id(current_doc.id)
    else
      reply = ReplyQuery.find(id.not_nil!)
      q = ReplyQuery.new.reply_id(reply.id)
    end

    q = q.id.desc_order if order_by == "desc"

    page, replies = paginate(q, per_page: 10)
    {count: page.item_count, replies: replies, page: page}
  end

  memoize def formatter : Tartrazine::Formatter
    Tartrazine::Html.new(
      theme: Tartrazine.theme("catppuccin-macchiato"),
      line_numbers: true,
      standalone: false,
    )
  end
end
