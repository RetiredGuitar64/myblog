class Docs::ReplyToDocForm < BaseComponent
  needs content : String = ""
  needs doc_path : String?
  needs reply_id : Int64?
  needs html_id : String = "tab"

  def render
    mount(Docs::Form, content: content, doc_path: doc_path, reply_id: reply_id, current_user: current_user, html_id: html_id) do
      me = current_user
      text = "回复"

      opts = {
        style:      "margin-right: 25px; margin-left: 10px;",
        hx_target:  "div#replies",
        hx_include: "[name='_csrf'],next textarea",
        script:     "on click set value of next <textarea/> to ''",
        hx_post:    Htmx::Docs::Reply::CreateOrUpdate.path_without_query_params,
      }

      if me.nil?
        opts = opts.merge(disabled: "")
      else
        if !reply_id.nil?
          # 一定是针对 reply 的 edit 或 new reply to reply，根据 content 是否有内容判断。
          if content.blank?
            opts = opts.merge(
              hx_vals: %({"user_id": #{me.id}, "id": #{reply_id}, "op": "new"}),
            )
          else
            opts = opts.merge(
              hx_vals: %({"user_id": #{me.id}, "id": #{reply_id}, "op": "edit"}),
            )
            text = "修改"
          end
        else
          # 为 doc 新建评论
          opts = opts.merge(
            hx_vals: %({"user_id": #{me.id}, "doc_path": "#{doc_path}"}),
          )
        end
      end

      span style: "float:right;" do
        if !reply_id.nil? && !me.nil?
          button(
            "取消",
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
