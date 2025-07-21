abstract class DocAction < BrowserAction
  include Lucky::Paginator::BackendHelpers
  include Auth::AllowGuests
  include PageHelpers

  expose formatter

  def replies_pagination(id_or_doc_path : String, order_by : String = "desc", per_page : Int32 = 10)
    return {count: 0, replies: ReplyQuery.new.none, page: nil, url: ""} unless order_by.in?("desc", "asc")

    id = id_or_doc_path.to_i64?

    if id.nil?
      doc_path = id_or_doc_path.starts_with?("/") ? id_or_doc_path : "/#{id_or_doc_path}"
      url = doc_path.sub("/docs", "/htmx/replies/docs")
      current_doc = DocQuery.new.path_index(doc_path).first
      q = ReplyQuery.new.doc_id(current_doc.id)
    else
      reply = ReplyQuery.find(id)
      q = ReplyQuery.new.reply_id(reply.id)
      url = "/htmx/replies/#{id}"
    end

    q = q.id.desc_order if order_by == "desc"

    page, replies = paginate(q, per_page: per_page)

    {
      count:   page.item_count,
      replies: replies,
      page:    page,
      url:     url,
    }
  end

  memoize def formatter : Tartrazine::Formatter
    Tartrazine::Html.new(
      theme: Tartrazine.theme("catppuccin-macchiato"),
      line_numbers: true,
      standalone: false,
    )
  end
end
