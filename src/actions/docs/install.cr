class Docs::Install < DocAction
  get "/docs/install" do
    html Docs::InstallPage
  end
end
