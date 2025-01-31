class Docs::PackageManager < DocAction
  get "/docs/package_manager" do
    html Docs::PackageManagerPage
  end
end
