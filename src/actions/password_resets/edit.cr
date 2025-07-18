class PasswordResets::Edit < BrowserAction
  include Auth::PasswordResets::Base
  include Auth::PasswordResets::TokenFromSession

  get "/password_resets/:user_id/edit" do
    html PasswordResets::NewPage, operation: ResetPassword.new, user_id: user_id.to_i64
  end
end
