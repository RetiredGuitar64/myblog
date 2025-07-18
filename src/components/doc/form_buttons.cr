class Docs::FormButtons < BaseComponent
  needs page_count : Int32 | Int64
  needs doc_path : String
  needs order_by : String

  def render
    reply_path = doc_path.sub("/docs", "/htmx/docs/replies")

    div class: "f-row align-items:center justify-content:space-between", style: "margin-top: 5px;" do
      span "共 #{page_count} 条回复"

      div class: "f-row align-items:center" do
        render_order_buttons(reply_path)
      end
    end
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
