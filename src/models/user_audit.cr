class UserAudit < BaseModel
  enum SyncStatus
    Pending = 1
    Handled = 2
    Staled  = 3
  end

  table do
    column user_id : Int64
    column changed_column_name : String
    column from : String
    column to : String
    column sync_state : UserAudit::SyncStatus = 1
  end
end
