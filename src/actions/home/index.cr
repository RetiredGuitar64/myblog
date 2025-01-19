class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    # html Lucky::WelcomePage
    redirect Docs::Index
  end
end
