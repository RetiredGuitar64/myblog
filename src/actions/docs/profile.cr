class Docs::Profile < DocAction
  get "/docs/profile" do
    html Docs::ProfilePage
  end
end
