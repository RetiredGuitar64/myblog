class Docs::Index < DocAction
  get "/docs/index" do
    html Docs::MarkdownsPage
  end
end
