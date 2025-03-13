class TopicReplies < BaseComponent
  needs formatter : Tartrazine::Formatter
  needs pagination : {count: Int32 | Int64, replies: ReplyQuery, page: Lucky::Paginator?}
  needs doc_path : String
  needs order_by : String

  def render
    count = pagination[:count]
    me = current_user
    reply_path = doc_path.sub("/docs", "/docs/htmx/replies")

    textarea_opt = {
      id:   "text_area",
      rows: 8,
      cols: 70,
      name: "content",
    }

    input_opt = {
      type:  "submit",
      value: "评论",
      style: "margin-right: 25px;",
    }

    if me.nil?
      textarea_opt = textarea_opt.merge(disabled: "")
      legend_text = "登录后添加评论"
      disabled = ""
      input_opt = input_opt.merge(disabled: "")
    else
      legend_text = "支持 markdown 格式"
      doc = DocQuery.new.path_index(doc_path).first
      input_opt = input_opt.merge(
        hx_post: "/docs/htmx/reply",
        hx_target: "#reply",
        hx_include: "[name='_csrf'],#text_area",
        hx_vals: %({"user_id": #{me.id}, "doc_id": #{doc.id}, "doc_path": "#{doc_path}"})
      )
    end

    # ---------------- page start ----------------

    div class: "<h4>" do
      text "共 #{count} 条回复"
    end

    div id: "tabs" do
      div role: "tablist", tableindex: "-1" do
        button(
          "输入",
          role: "tab",
          id: "tab-1",
          aria_controls: "panel-1",
          tabindex: "0",
          aria_selected: "true"
        )

        button(
          role: "tab",
          id: "tab-2",
          aria_controls: "panel-2",
          tabindex: "-1",
          hx_get: "/docs/htmx/markdown_render",
          hx_target: "#markdown-preview",
          hx_include: "#text_area",
          hx_indicator: "next img.htmx-indicator"
        ) do
          text "预览"
        end
      end

      div role: "tabpanel", id: "panel-1", aria_labelledby: "tab-1" do
        form do
          fieldset do
            # legend legend_text

            para do
              label legend_text, id: "text_area", style: "margin-bottom: 8px;"

              textarea textarea_opt
            end
          end
        end
      end
      div role: "tabpanel", id: "panel-2", aria_labelledby: "tab-2", hidden: "" do
        para id: "markdown-preview" do
        end
        mount Shared::Spinner, text: "正在预览..."
      end
    end

    # 这里利用了一个狡黠的 htmx hack，点击下面的连接，生成的 url 如下：
    # /docs/index/replies?order_by=asc&order_by=desc
    # 此时有两个 order_by，第一个来自于 hx_get, 第二个来自于 hx_include
    # 此时，总是第一个生效。
    selected = "background-color: white; font-weight: bold; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);"
    unselected = "background-color: #E2E7EB; border: none; text-decoration: none;"

    # fieldset class: "f-col align-items:end" do
    div class: "f-row align-items:center justify-content:end" do
      input(input_opt)
      a(
        "最早",
        class: "chip",
        herf: "",
        hx_get: "#{reply_path}?order_by=asc",
        hx_target: "#reply",
        hx_include: "#order_by",
        style: order_by == "asc" ? selected : unselected
      )

      a(
        "最新",
        class: "chip",
        href: "",
        hx_get: "#{reply_path}?order_by=desc",
        hx_target: "#reply",
        hx_include: "#order_by",
        style: order_by == "desc" ? selected : unselected
      )
    end

    input type: "hidden", name: "order_by", value: order_by, id: "order_by"

    div id: "replies" do
      mount(
        ReplyMore,
        formatter: formatter,
        pagination: pagination,
        page_number: 1,
        current_user: current_user,
        reply_path: reply_path
      )
    end

    # ---------------- page end ----------------
  end
end
