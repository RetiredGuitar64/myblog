class Htmx::Docs::Replies < DocAction
  param order_by : String = "desc"

  get "/htmx/replies/*:id_or_doc_path" do
    page_number = params.get?(:page).try &.to_i

    return head 401 if id_or_doc_path.nil?

    id_or_doc_path = self.id_or_doc_path.not_nil!

    pagination = replies_pagination(id_or_doc_path: id_or_doc_path, order_by: order_by)

    id = id_or_doc_path.to_i64?

    if page_number && page_number > 1
      component(
        ::Docs::RepliesMore,
        formatter: formatter,
        pagination: pagination,
        page_number: page_number,
        current_user: current_user,
        reply_id: id
      )
    else
      component(
        ::Docs::Replies,
        formatter: formatter,
        pagination: pagination,
        current_user: current_user,
        order_by: order_by,
        reply_id: id
      )
    end
  end
end
