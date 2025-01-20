class SignUps::Create < BrowserAction
  include Auth::RedirectSignedInUsers

  post "/sign_up" do
    SignUpUser.create(params) do |operation, user|
      if user
        flash.info = "注册成功"
        sign_in(user)
        redirect to: Home::Index
      else
        flash.failure = "注册失败"
        html NewPage, operation: operation
      end
    end
  end
end
