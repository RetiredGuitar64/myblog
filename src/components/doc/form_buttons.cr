class Docs::FormButtons < BaseComponent
  needs page_count : Int32 | Int64
  needs reply_path : String
  needs order_by : String
  needs hx_target : String

  def render
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

    [{"最早", "asc"}, {"最新", "desc"}].each do |title, order|
      a(
        title,
        class: "chip",
        herf: "",
        hx_get: "#{reply_path}?order_by=#{order}",
        hx_target: hx_target,
        hx_swap: "outerHTML",
        hx_include: "next input[name='order_by']",
        style: order_by == order ? selected : unselected,
      )
    end

    # 为了记录上次点击的 order_by 顺序，传递 order_by 到服务器，并重新写入隐藏 input
    input type: "hidden", name: "order_by", value: order_by
  end
end
