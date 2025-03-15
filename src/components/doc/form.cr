class Docs::Form < BaseComponent
  def render
    render_tabs
  end

  private def render_tabs
    div id: "tabs" do
      div role: "tablist", tableindex: "-1", aria_label: "" do
        button(
          "输入",
          role: "tab",
          id: "tab-1",
          aria_controls: "panel-1",
          tabindex: "0",
          aria_selected: "true"
        )

        button(
          "预览",
          role: "tab",
          id: "tab-2",
          aria_controls: "panel-2",
          tabindex: "-1",
          hx_put: "/docs/htmx/markdown_render",
          hx_target: "#markdown-preview",
          hx_include: "[name='_csrf'],#text_area",
          hx_indicator: "next img.htmx-indicator",
          style: "pointer-events: none;cursor: not-allowed;"
        )
      end

      div role: "tabpanel", id: "panel-1", aria_labelledby: "tab-1" do
        render_form
      end

      div role: "tabpanel", id: "panel-2", aria_labelledby: "tab-2", hidden: "" do
        render_preview
      end
    end
  end

  private def render_form
    me = current_user

    textarea_opt = {
      id:   "text_area",
      rows: 8,
      cols: 70,
      name: "content",
    }

    if me.nil?
      legend_text = "登录后添加评论"
      textarea_opt = textarea_opt.merge(disabled: "")
    else
      legend_text = "支持 markdown 格式"
      textarea_opt = textarea_opt.merge(script: "on change set @style of <#tab-2/> to ''")
    end

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

  private def render_preview
    para id: "markdown-preview"
    mount Shared::Spinner, text: "正在预览..."
  end
end
