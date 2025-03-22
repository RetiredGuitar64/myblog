class Me::Show < BrowserAction
  get "/me" do
    html Me::ShowPage
  end
end
