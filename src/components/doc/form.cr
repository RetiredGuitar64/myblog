class Docs::Form < BaseComponent
  needs content : String = ""
  needs doc_path : String?
  needs reply_id : Int64?
  needs html_id : String = "tab"

  def render(&)
    me = current_user
    # 修改1：最外层容器改为圆角和半透明白色背景
    div class: "rounded-lg border border-gray-300 bg-white/50", style: "padding: 5px;", id: "#{html_id}-form" do
      div class: "tab-frame", style: "margin-top: 5px;text-align: center; min-height: 350px;" do
        input type: "radio", checked: "", name: "#{html_id}", id: "#{html_id}1"
        # 修改2：美化按钮样式
        label "输入", for: "#{html_id}1", class: "py-1 px-3 rounded border border-gray-300 hover:bg-gray-100 bg-white/80", style: "margin-right: 5px;"

        input(
          type: "radio",
          name: "#{html_id}",
          id: "#{html_id}2",
          hx_put: Htmx::Docs::MarkdownRender.path_without_query_params,
          hx_target: "next p.markdown-preview",
          hx_include: "[name='_csrf'],next textarea",
          hx_indicator: "next img.htmx-indicator",
        )
        # 修改2：美化按钮样式
        label(
          "预览",
          for: "#{html_id}2",
          class: "py-1 px-3 rounded border border-gray-300 hover:bg-gray-100 bg-white/60",
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

        output style: "display: inline-block;" do
          text me.nil? ? "登录后添加评论" : "支持 markdown 格式"
        end

        yield

        div class: "tab" do
          render_form
        end
        div class: "tab reset-tw", style: "text-align: initial;" do
          render_preview
        end
      end
    end
  end

  private def render_form
    me = current_user

    textarea_opt = {
      id:   "#{html_id}_text_area",
      rows: 16,
      cols: 60,
      name: "content",
    }

    textarea_opt = textarea_opt.merge(disabled: "") if me.nil?

    form do
      para do
        textarea textarea_opt do
          text content
        end
      end
    end
  end

  private def render_preview
    para class: "markdown-preview"
    mount Shared::Spinner, text: "正在预览..."
  end
end
