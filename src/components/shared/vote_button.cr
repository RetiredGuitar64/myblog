class Shared::VoteButton < BaseComponent
  needs reply_id : Int64?
  needs doc_id : Int64?
  needs votes : Hash(String, Int32)
  needs voted_types : Array(String)

  def render
    div class: "flex gap-1" do
      votes.each do |(emoji, count)|
        # 基础样式类
        button_classes = ["flex items-center justify-center",
                         "w-[35px] h-[15px] text-xs",
                         "rounded border border-gray-300",  # 更柔和的边框颜色
                         count == 0 ? "opacity-50 grayscale" : ""]
        
        # 投票状态样式
        if emoji.in?(voted_types)
          button_classes += ["bg-white/60", "shadow-sm", "border-gray-100"]  # 选中状态样式
        else
          button_classes << "hover:bg-gray-100"  # 未选中状态的悬停效果
        end

        # 按钮配置
        config = {
          class: button_classes.join(" "),
          type: "button"
        }

        if current_user
          if reply_id
            hx_values = %({"user_id": #{current_user.not_nil!.id}, "vote_type": "#{emoji}", "reply_id": #{reply_id.not_nil!}})
          else
            hx_values = %({"user_id": #{current_user.not_nil!.id}, "vote_type": "#{emoji}", "doc_id": #{doc_id.not_nil!}})
          end

          config = config.merge(
            {
              hx_patch: Htmx::Docs::Vote.path_without_query_params,
              hx_include: "[name='_csrf']",
              hx_vals: hx_values,
              hx_target: "closest div",
            }
          )
        end

        button("#{emoji}#{count}", config)
      end
    end
  end
end