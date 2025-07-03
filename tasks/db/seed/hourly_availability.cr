require "../../../spec/support/factories/**"
require "timecop"

class Db::Seed::HourlyAvailability < LuckyTask::Task
  summary "Add hourly availability initialize data"

  def call
    now = Time.local
    year = now.year
    month = now.month
    start_day = 1
    end_day = now.at_end_of_month.day

    # HourlyAvailabilityQuery.truncate

    (start_day..end_day).each do |day|
      date = Time.local(year, month, day).to_s("%Y-%m-%d")

      ["09", "10", "11", "12", "13", "14", "15", "16", "17"].each do |hour|
        SaveHourlyAvailability.upsert!(
          date: date,
          hour: hour
        )
      end
    end
  end
end
