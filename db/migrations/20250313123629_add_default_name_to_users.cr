class AddDefaultNameToUsers::V20250313123629 < Avram::Migrator::Migration::V1
  def migrate
    UserQuery.new.each do |record|
      while (user_name = "User#{rand(100000..999999)}")
        if UserQuery.new.name(user_name).none?
          break
        end
      end
      UpdateUser.update!(record, name: user_name)
    end
    make_required table_for(User), :name
  end

  def rollback
    # drop table_for(Thing)
  end
end
