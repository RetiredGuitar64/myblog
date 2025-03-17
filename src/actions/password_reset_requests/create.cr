class PasswordResetRequests::Create < BrowserAction
  include Auth::RedirectSignedInUsers

  post "/password_reset_requests" do
    RequestPasswordReset.run(params) do |operation, user|
      if user
        PasswordResetRequestEmail.new(user).deliver
        flash.success = "请仔细检查你的邮箱获取重置密码的链接"
        redirect SignIns::New
      else
        html NewPage, operation: operation
      end
    end
  end
end
