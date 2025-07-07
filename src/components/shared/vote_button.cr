class Shared::VoteButton < BaseComponent
  needs reply_id : Int64?
  needs doc_id : Int64?
  needs votes : Hash(String, Int32)
  needs voted_types : Array(String)

  def render
    votes.each do |(emoji, count)|
      gray = count == 0 ? "filter: grayscale(100%); color: #ccc;" : ""

      voted = emoji.in?(voted_types) ? "border: 1px solid #000;" : ""
      config = {
        class: "iconbutton f-col align-items:center emoji",
        type:  "button",
        style: "width: 35px; height: 15px; font-size:12px;#{gray}#{voted}",
      }

      if current_user
        if reply_id
          hx_values = %({"user_id": #{current_user.not_nil!.id}, "vote_type": "#{emoji}", "reply_id": #{reply_id.not_nil!}})
        else
          hx_values = %({"user_id": #{current_user.not_nil!.id}, "vote_type": "#{emoji}", "doc_id": #{doc_id.not_nil!}})
        end

        config = config.merge(
          {
            hx_patch:   Htmx::Docs::Vote.path_without_query_params,
            hx_include: "[name='_csrf']",
            hx_vals:    hx_values,
            hx_target:  "closest div",
          },
        )
      end

      button("#{emoji}#{count}", config)
    end
  end
end
