class AddFieldsInPreferencesAsColumn::V20250315145853 < Avram::Migrator::Migration::V1
  def migrate
    # Read more on migrations
    # https://www.luckyframework.org/guides/database/migrations
    #
    alter table_for(Reply) do
      add user_name : String?
      add user_avatar : String?
    end
  end

  def rollback
    alter table_for(Reply) do
      remove :user_name
      remove :avatar
    end
  end
end
