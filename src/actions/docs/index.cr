class Docs::Index < DocAction
  get "/docs/index" do
    html Docs::IndexPage
  end
end
