class Htmx::Docs::Replies < DocAction
  param order_by : String = "desc"

  get "/htmx/docs/replies/*:markdown_path" do
    page_number = params.get?(:page).try &.to_i

    id_or_path = markdown_path

    return head 401 if id_or_path.nil?

    id = id_or_path.to_i64?

    if id.nil?
      pagination = replies_pagination(doc_path: "/docs/#{id_or_path}", order_by: order_by)
    else
      pagination = replies_pagination(id: id, order_by: order_by)
    end

    if page_number && page_number > 1
      component(
        ::Docs::RepliesMore,
        formatter: formatter,
        pagination: pagination,
        page_number: page_number,
        current_user: current_user,
        reply_path: "/htmx/docs/replies/#{id_or_path}",
        reply_id: id
      )
    else
      component(
        ::Docs::Replies,
        formatter: formatter,
        pagination: pagination,
        current_user: current_user,
        doc_path: "/docs/#{id_or_path}",
        order_by: order_by,
        reply_id: id,
      )
    end
  end
end
