class Docs::ForAdvancedRubyists::Methods < DocAction
  get "/docs/for_advanced_rubyists/methods" do
    html Docs::ForAdvancedRubyists::MethodsPage
  end
end
