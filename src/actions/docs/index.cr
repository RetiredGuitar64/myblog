class Docs::Index < DocAction
  get "/docs" do
    html Docs::IndexPage
  end
end
