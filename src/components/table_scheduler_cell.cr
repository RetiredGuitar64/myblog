class TableSchedulerCell < BaseComponent
  needs date : String
  needs hour : String
  needs available : Bool
  needs comment : String?

  def render
    me = current_user

    if me && me.email == ENV["ADMIN_EMAIL"]?
      opts = {
        hx_post:    Htmx::HourlySchedule.path_without_query_params,
        hx_include: "[name='_csrf']",
        hx_prompt:  "修改预约（#{date} #{hour}:00）",
        hx_swap:    "outerHTML",
        hx_vals:    "{\"date\": \"#{date}\", \"hour\": \"#{hour}\"}",
      }

      opts = opts.merge(data_tooltip: comment.to_s) if comment.present?

      td(available? ? "🟢" : "🔴", opts)
    else
      td(available? ? "🟢" : "🔴")
    end
  end
end
