class Docs::Basic < BrowserAction
  get "/docs/basic" do
    html Docs::BasicPage
  end
end
