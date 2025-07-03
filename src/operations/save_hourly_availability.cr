class SaveHourlyAvailability < HourlyAvailability::SaveOperation
  upsert_lookup_columns :date, :hour
end
