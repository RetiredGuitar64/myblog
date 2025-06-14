class Version::Index < BrowserAction
  # include Auth::AllowGuests

  get "/version" do
    plain_text App::VERSION
  end
end
