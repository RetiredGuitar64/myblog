class Docs::Basic < DocAction
  get "/docs/basic" do
    html Docs::BasicPage
  end
end
