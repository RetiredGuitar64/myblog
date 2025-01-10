class Docs::Index < BrowserAction
  get "/docs" do
    html Docs::IndexPage
  end
end
