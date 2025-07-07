class Htmx::Docs::Replies < DocAction
  param order_by : String = "desc"

  get "/htmx/docs/replies/*:markdown_path" do
    page_number = params.get?(:page).try &.to_i
    pagination = replies_pagination(doc_path: "/docs/#{markdown_path}", order_by: order_by)

    if page_number && page_number > 1
      component(
        ::Docs::RepliesMore,
        formatter: formatter,
        pagination: pagination,
        page_number: page_number,
        current_user: current_user,
        reply_path: "/htmx/docs/replies/#{markdown_path}"
      )
    else
      component(
        ::Docs::Replies,
        formatter: formatter,
        pagination: pagination,
        current_user: current_user,
        doc_path: "/docs/#{markdown_path}",
        order_by: order_by
      )
    end
  end
end
