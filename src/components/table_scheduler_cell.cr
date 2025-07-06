class TableSchedulerCell < BaseComponent
  needs date : String
  needs hour : String
  needs available : Bool
  needs comment : String?

  def render
    me = current_user

    cell_hour_time = Time.parse("#{date} #{hour}:59", "%Y-%m-%d %H:%M", Time::Location.load("Asia/Shanghai"))
    opts = {
      class: Time.local > cell_hour_time ? "disabled" : "",
    }

    if me && me.email == ENV["ADMIN_EMAIL"]?
      opts = opts.merge(
        {
          hx_post:    Htmx::HourlySchedule.path_without_query_params,
          hx_include: "[name='_csrf']",
          hx_prompt:  "修改预约（#{date} #{hour}:00）",
          hx_swap:    "outerHTML",
          hx_vals:    "{\"date\": \"#{date}\", \"hour\": \"#{hour}\"}",
        })

      opts = opts.merge(data_tooltip: comment.to_s) if comment.present?
    end

    td(available? ? "🟢" : "🔴", opts)
  end
end
