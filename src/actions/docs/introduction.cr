class Docs::Introduction < BrowserAction
  get "/docs/introduction" do
    html Docs::IntroductionPage
  end
end
