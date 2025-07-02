class Docs::FirstBlog < DocAction
  get "/docs/first_blog" do
    html Docs::FirstBlogPage
  end
end
