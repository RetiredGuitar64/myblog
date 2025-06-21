class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    html Home::IndexPage
  end
end
