class HourlyAvailability < BaseModel
  table do
    column date : String
    column hour : String
    column available : Bool = true
    column comment : String?
  end
end
