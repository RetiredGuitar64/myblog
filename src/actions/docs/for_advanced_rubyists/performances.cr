class Docs::ForAdvancedRubyists::Performance < DocAction
  get "/docs/for_advanced_rubyists/performance" do
    html Docs::ForAdvancedRubyists::PerformancePage
  end
end
