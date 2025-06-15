class Docs::Replies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs doc_path : String
  needs order_by : String

  def render
    reply_path = doc_path.sub("/docs", "/docs/htmx/replies")

    div class: "f-row align-items:center justify-content:space-between" do
      span "共 #{pagination[:count]} 条回复"

      div class: "f-row align-items:center justify-content:end" do
        render_submit_button

        render_order_buttons(reply_path)
      end
    end

    div id: "replies" do
      mount(
        Docs::RepliesMore,
        formatter: formatter,
        pagination: pagination,
        page_number: 1,
        current_user: current_user,
        reply_path: reply_path
      )
    end
  end

  private def render_submit_button
    me = current_user

    input_opt = {
      type:  "submit",
      value: "评论",
      style: "margin-right: 25px;",
    }

    if me.nil?
      input_opt = input_opt.merge(disabled: "")
    else
      doc = DocQuery.new.path_index(doc_path).first
      input_opt = input_opt.merge(
        hx_post: Docs::Htmx::Reply.path_without_query_params,
        hx_target: "#form_with_replies",
        hx_include: "[name='_csrf'],#text_area",
        hx_vals: %({"user_id": #{me.id}, "doc_id": #{doc.id}, "doc_path": "#{doc_path}"})
      )
    end

    input(input_opt)
  end

  private def render_order_buttons(reply_path : String)
    selected = "background-color: white; font-weight: bold; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);"
    unselected = "background-color: #E2E7EB; border: none; text-decoration: none;"

    # 这里利用了一个狡黠的 htmx hack，点击下面的连接，生成的 url 如下：
    # /docs/replies/index?order_by=asc&order_by=desc
    # 此时有两个 order_by，第一个来自于 hx_get 中的 ? 参数, 第二个来自于 hx_include
    # 此时，总是第一个生效。
    a(
      "最早",
      class: "chip",
      herf: "",
      hx_get: "#{reply_path}?order_by=asc",
      hx_target: "#replies",
      hx_include: "#order_by",
      style: order_by == "asc" ? selected : unselected
    )

    a(
      "最新",
      class: "chip",
      href: "",
      hx_get: "#{reply_path}?order_by=desc",
      hx_target: "#replies",
      hx_include: "#order_by",
      style: order_by == "desc" ? selected : unselected
    )

    # 为了记录上次点击的 order_by 顺序，传递 order_by 到服务器，并重新写入隐藏 input
    input type: "hidden", name: "order_by", value: order_by, id: "order_by"
  end
end
