class Docs::ForAdvancedRubyists::Performances < DocAction
  get "/docs/for_advanced_rubyists/performances" do
    html Docs::ForAdvancedRubyists::PerformancesPage
  end
end
