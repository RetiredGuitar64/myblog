class Home::Index < BrowserAction
  get "/" do
    redirect Docs::Index
  end
end
