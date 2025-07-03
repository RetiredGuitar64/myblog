class Db::Seed::HourlyAvailability < LuckyTask::Task
  summary "Add hourly availability initialize data"

  def call
    now = Time.local
    Db::Seed::HourlyAvailabilityTask.run(now.year, now.month)
  end
end

module Db::Seed::HourlyAvailabilityTask
  def self.run(year, month)
    start_day = 1
    end_day = Time.local(year, month, 1).at_end_of_month.day

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
