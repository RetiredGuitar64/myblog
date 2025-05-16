class UpdateReplyFloor < Reply::SaveOperation
  attribute floor : Int32

  before_save do
    # Check https://github.com/luckyframework/lucky/issues/1956
    if prefs = preferences.value
      prefs.floor = floor.value.not_nil!
      preferences.value = prefs
    end
  end
end
