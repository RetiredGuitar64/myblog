class Docs::Form < BaseComponent
  needs content : String = ""
  needs doc_path : String
  needs reply_id : Int64?

  def render
    div style: "border:0.5px solid gray; padding: 5px;", id: "form" do
      render_tabs
    end
  end

  private def render_tabs
    div class: "tab-frame", style: "margin-top: 5px;" do
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

      render_submit_button

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

  private def render_submit_button
    me = current_user
    text = "回复"

    opts = {
      style:      "margin-right: 25px; margin-left: 10px;",
      hx_target:  "#form_with_replies",
      hx_include: "[name='_csrf'],next textarea",
    }

    if me.nil?
      opts = opts.merge(disabled: "")
    else
      if !reply_id.nil?
        text = "提交"
        opts = opts.merge(
          hx_patch: Docs::Htmx::Reply::Update.path_without_query_params(id: reply_id.not_nil!),
          hx_vals: %({"user_id": #{me.id}})
        )
      else
        doc = DocQuery.new.path_index(doc_path).first
        opts = opts.merge(
          hx_post: Docs::Htmx::Reply::Create.path_without_query_params,
          hx_vals: %({"user_id": #{me.id}, "doc_id": #{doc.id}, "doc_path": "#{doc_path}"})
        )
      end
    end

    span style: "float:right;" do
      if !reply_id.nil? && !me.nil?
        button(
          "取消",
          hx_get: Docs::Htmx::Reply::New.with(doc_path: doc_path, user_id: me.id).path,
          hx_swap: "outerHTML",
          hx_target: "#form"
        )
      end
      strong do
        button(text, opts)
      end
    end
  end
end
