class Docs::ReplyToDocForm < BaseComponent
  needs content : String = ""
  needs html_id : String = "tab"
  needs doc_path : String?
  needs reply_id : Int64?

  def render
    mount(
      Docs::Form,
      content: content,
      doc_path: doc_path,
      reply_id: reply_id,
      current_user: current_user,
      html_id: html_id
    ) do
      me = current_user
      text = "回复"

      opts = {
        style: "margin-right: 25px; margin-left: 10px; padding: 6px 12px; background: #3b82f6; color: white; border-radius: 4px; border: none; cursor: pointer;", # 仅添加内联样式
        hx_target:  "div#replies",
        hx_include: "[name='_csrf'],next textarea",
        script:     "on click set value of next <textarea/> to ''",
        hx_post:    Htmx::Docs::Reply::CreateOrUpdate.path_without_query_params,
        onclick:    "document.getElementById('edit_dialog').close();",
      }

      if me.nil?
        opts = opts.merge(disabled: "", style: "#{opts[:style]} background: #cccccc;") # 禁用状态变灰
      else
        if !reply_id.nil?
          if content.blank?
            opts = opts.merge(
              hx_vals: %({"user_id": #{me.id}, "id": #{reply_id}, "op": "new"}),
              hx_target: "#doc_reply-#{reply_id}-replies",
              hx_swap: "outerHTML"
            )
          else
            reply = ReplyQuery.find(reply_id.not_nil!)

            if !(id = reply.reply_id).nil?
              opts = opts.merge(
                hx_target: "#doc_reply-#{id}-replies"
              )
            end

            opts = opts.merge(
              hx_vals: %({"user_id": #{me.id}, "id": #{reply_id}, "op": "edit"}),
              hx_swap: "outerHTML",
              onclick: "scrollToElementById('doc_reply-#{reply_id}')",
              style: "#{opts[:style]} background: #10b981;" # 修改按钮变绿
            )
            text = "修改"
          end
        else
          opts = opts.merge(
            hx_vals: %({"user_id": #{me.id}, "doc_path": "#{doc_path}"}),
          )
        end
      end

      span style: "float:right;" do
        if !reply_id.nil? && !me.nil?
          button(
            "取消",
            style: "padding: 6px 12px; background: #e5e7eb; color: #333; border-radius: 4px; border: none; cursor: pointer; margin-right: 10px;", # 取消按钮样式
            onclick: "document.getElementById('edit_dialog').close();"
          )
        end
        strong do
          button(text, opts)
        end
      end
    end
  end
end