class Docs::ReplyToDocForm < BaseComponent
  needs content : String = ""
  needs doc_path : String
  needs reply_id : Int64?
  needs msg : String?

  def render
    mount(Docs::Form, content: content, doc_path: doc_path, reply_id: reply_id, msg: msg, current_user: current_user) do
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
        if !reply_id.nil? && !me.nil?
          text = "提交"
          opts = opts.merge(
            hx_patch: Htmx::Docs::Reply::Update.path_without_query_params(id: reply_id.not_nil!),
            hx_vals: %({"user_id": #{me.id}})
          )
        else
          opts = opts.merge(
            hx_post: Htmx::Docs::Reply::Create.path_without_query_params,
            hx_vals: %({"user_id": #{me.id}, "doc_path": "#{doc_path}"})
          )
        end
      end

      span style: "float:right;" do
        if !reply_id.nil? && !me.nil?
          button(
            "取消",
            hx_get: Htmx::Docs::Reply::New.with(doc_path: doc_path, user_id: me.id).path,
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
end
