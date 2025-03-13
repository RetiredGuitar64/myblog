class Shared::VoteButton < BaseComponent
  needs votes : Hash(String, Int32)
  needs reply_id : Int64
  needs voted_types : Array(String)

  def render
    votes.each do |(emoji, count)|
      gray = count == 0 ? "filter: grayscale(100%); color: #ccc;" : ""

      voted = emoji.in?(voted_types) ? "border: 1px solid #000;" : ""
      config = {
        class: "iconbutton f-col align-items:center",
        type:  "button",
        style: "width: 35px; height: 15px; font-size:12px;#{gray}#{voted}",
      }

      if current_user
        config = config.merge(
          {
            hx_patch:   "/docs/htmx/vote",
            hx_include: "[name='_csrf']",
            hx_vals:    "{\"user_id\": #{current_user.not_nil!.id}, \"reply_id\": #{reply_id}, \"vote_type\": \"#{emoji}\"}",
            hx_target:  "closest div",
          },
        )
      end

      button("#{emoji}#{count}", config)
    end
  end
end
