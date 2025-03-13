class Docs::Htmx::Replies < DocAction
  param order_by : String = "desc"

  get "/docs/htmx/replies/*:doc_file_name" do
    page_number = params.get?(:page).try &.to_i
    pagination = replies_pagination(doc_path: "/docs/#{doc_file_name}", order_by: order_by)

    if page_number && page_number > 1
      component(
        Docs::ReplyMore,
        formatter: formatter,
        pagination: pagination,
        page_number: page_number,
        current_user: current_user,
        reply_path: "/docs/htmx/replies/#{doc_file_name}"
      )
    else
      component(
        Docs::TopicReplies,
        formatter: formatter,
        pagination: pagination,
        current_user: current_user,
        doc_path: "/docs/#{doc_file_name}",
        order_by: order_by
      )
    end
  end
end
