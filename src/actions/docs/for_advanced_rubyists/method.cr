class Docs::ForAdvancedRubyists::Method < DocAction
  get "/docs/for_advanced_rubyists/method" do
    html Docs::ForAdvancedRubyists::MethodPage
  end
end
