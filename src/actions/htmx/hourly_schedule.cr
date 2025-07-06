class Htmx::HourlySchedule < BrowserAction
  param date : String
  param hour : String

  post "/htmx/hourly_schedule" do
    return head 401 if current_user.nil?
    me = current_user

    return head 401 if me.email != ENV["ADMIN_EMAIL"]?

    cell_hour_time = Time.parse("#{date} #{hour}:59", "%Y-%m-%d %H:%M", Time::Location.load("Asia/Shanghai"))

    return head 401 if Time.local > cell_hour_time

    record = HourlyAvailabilityQuery.new.date(date).hour(hour).first?
    comment = request.headers["HX-Prompt"]?

    if record.nil?
      record = SaveHourlyAvailability.create!(
        date: date,
        hour: hour,
        comment: comment,
      )
    else
      available = !record.available && comment.blank?

      SaveHourlyAvailability.update!(
        record,
        comment: comment,
        available: available
      )
    end

    record = record.reload

    MARKDOWN_CACHE.clear

    component(
      TableSchedulerCell,
      date: record.date,
      hour: record.hour,
      available: record.available,
      comment: record.comment,
      current_user: me
    )
  end
end
