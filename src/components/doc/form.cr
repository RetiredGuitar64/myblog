class Docs::Form < BaseComponent
  needs content : String = ""
  needs doc_path : String
  needs reply_id : Int64?
  needs msg : String?
  needs html_id : String = "tab"

  def render(&)
    div style: "border:0.5px solid gray; padding: 5px;", id: "#{html_id}-form" do
      div class: "tab-frame", style: "margin-top: 5px;text-align: center; min-height: 350px;" do
        input type: "radio", checked: "", name: "#{html_id}", id: "#{html_id}1"
        label "输入", for: "#{html_id}1"

        input(
          type: "radio",
          name: "#{html_id}",
          id: "#{html_id}2",
          hx_put: Htmx::Docs::MarkdownRender.path_without_query_params,
          hx_target: "next p.markdown-preview",
          hx_include: "[name='_csrf'],next textarea",
          hx_indicator: "next img.htmx-indicator",
        )
        label(
          "预览",
          for: "#{html_id}2",
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

        if msg
          output script: <<-'HEREDOC', style: "display: inline-block; color: green;" do
init transition my opacity to 0% over 3 seconds
HEREDOC
            text msg.to_s
          end
        end

        yield

        div class: "tab" do
          render_form
        end
        div class: "tab", style: "text-align: initial;" do
          render_preview
        end
      end
    end
  end

  private def render_form
    me = current_user

    textarea_opt = {
      id:   "#{html_id}_text_area",
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
          label legend_text, for: "#{html_id}_text_area", style: "margin-bottom: 8px;"

          textarea textarea_opt do
            text content
          end
        end
      end
    end
  end

  private def render_preview
    para class: "markdown-preview"
    mount Shared::Spinner, text: "正在预览..."
  end
end
