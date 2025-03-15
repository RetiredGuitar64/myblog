class UpdateUserNameForReply::V20250315152616 < Avram::Migrator::Migration::V1
  def migrate
    ReplyQuery.new.each do |reply|
      SaveReply.update!(reply, user_name: reply.preferences.user_name)
    end
    make_required table_for(Reply), :user_name
  end

  def rollback
    # drop table_for(Thing)
  end
end
