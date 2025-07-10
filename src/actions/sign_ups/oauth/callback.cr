class SignUps::Oauth::Callback < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/multi_auth/:provider/callback" do
    redirect_uri = "#{Lucky::RouteHelper.settings.base_uri}/multi_auth/#{provider}/callback"
    auth_user = MultiAuth.make(provider, redirect_uri).user(request.query_params)

    # 似乎 Github 和 Google 以下字段都不为空。
    name = auth_user.name.not_nil!
    avatar = auth_user.image.not_nil!
    email = auth_user.email.not_nil!

    if (user = UserQuery.new.email(email).first?).nil?
      user = OAuthUser.create!(
        email: email,
        name: name,
        avatar: avatar,
      )
    end

    flash.success = "登录成功"

    sign_in(user)

    Authentic.redirect_to_originally_requested_path(self, fallback: Home::Index)
  end
end
