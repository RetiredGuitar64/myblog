class PasswordResets::Create < BrowserAction
  include Auth::PasswordResets::Base
  include Auth::PasswordResets::TokenFromSession

  post "/password_resets/:user_id" do
    ResetPassword.update(user, params) do |operation, user|
      if operation.saved?
        session.delete(:password_reset_token)
        sign_in user
        flash.success = "密码重置成功"
        redirect to: Home::Index
      else
        html NewPage, operation: operation, user_id: user_id.to_i64
      end
    end
  end
end
