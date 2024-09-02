class Version::Index < BrowserAction
  get "/version" do
    plain_text "Deployed version: #{App::DEPLOYED_VERSION}"
  end
end
