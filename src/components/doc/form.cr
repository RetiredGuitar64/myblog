class Docs::Form < BaseComponent
  needs content : String = ""

  def render
    div style: "border:0.5px solid gray; padding: 5px;" do
      render_tabs
    end
  end

  private def render_tabs
    div class: "tab-frame" do
      input type: "radio", checked: "", name: "tab", id: "tab1"
      label "输入", for: "tab1"

      input(
        type: "radio",
        name: "tab",
        id: "tab2",
        hx_put: Docs::Htmx::MarkdownRender.path_without_query_params,
        hx_target: "#markdown-preview",
        hx_include: "[name='_csrf'],next textarea",
        hx_indicator: "next img.htmx-indicator",
      )
      label(
        "预览",
        for: "tab2",
        script: "on mouseover set x to the value of the next <textarea/>
        then if x == ''
           add @disabled to the previous <input/>
           then set the style of me to 'cursor: not-allowed;'
        else
          remove @disabled from the previous <input/>
          then remove @style from me
        end
        "
      )

      div class: "tab" do
        render_form
      end
      div class: "tab" do
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
    end

    form do
      fieldset do
        para do
          label legend_text, for: "text_area", style: "margin-bottom: 8px;"

          textarea textarea_opt do
            text content
          end
        end
      end
    end
  end

  private def render_preview
    para id: "markdown-preview"
    mount Shared::Spinner, text: "正在预览..."
  end
end
