class Docs::Introduction < DocAction
  get "/docs/introduction" do
    html Docs::IntroductionPage
  end
end
