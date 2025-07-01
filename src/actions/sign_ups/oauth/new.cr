class SignUps::Oauth::New < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/multi_auth/:provider" do
    redirect_uri = "https://crystal-china.org/multi_auth/#{provider}/callback"
    authorize_uri = MultiAuth.make(provider, redirect_uri).authorize_uri(scope: "email")

    redirect authorize_uri
  end
end
