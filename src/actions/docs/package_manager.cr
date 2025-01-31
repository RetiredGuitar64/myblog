class Docs::PackageManager < DocAction
  get "/docs/packagemanager" do
    html Docs::PackageManagerPage
  end
end
