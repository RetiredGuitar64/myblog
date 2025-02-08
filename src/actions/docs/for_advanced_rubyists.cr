class Docs::ForRubyists < DocAction
  get "/docs/for_advanced_rubyists" do
    html Docs::ForAdvancedRubyistsPage
  end
end
