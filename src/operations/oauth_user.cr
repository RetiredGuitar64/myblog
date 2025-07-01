class OAuthUser < User::SaveOperation
  permit_columns email, name, avatar

  before_save do
    validate_uniqueness_of email

    user_name = name.value

    while UserQuery.new.name(user_name.not_nil!).any?
      user_name = "#{user_name}#{rand(100..999)}"
    end

    self.name.value = user_name
  end
end
