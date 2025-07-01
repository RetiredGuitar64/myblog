class SignUps::Oauth::Callback < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/multi_auth/:provider/callback" do
    redirect_uri = "https://crystal-china.org/multi_auth/#{provider}/callback"
    auth_user = MultiAuth.make(provider, redirect_uri).user(request.query_params)
    email = auth_user.email.not_nil!

    if (user = UserQuery.new.email(email).first?).nil?
      pwd = Random.base58(10)

      # 这里需要一个随便的 captcha 来通过验证
      user = SignUpUser.create!(
        email: email,
        password: pwd,
        password_confirmation: pwd,
        captcha: "foo"
      )
    end

    flash.success = "登录成功"

    sign_in(user)

    Authentic.redirect_to_originally_requested_path(self, fallback: Home::Index)
  end
end
