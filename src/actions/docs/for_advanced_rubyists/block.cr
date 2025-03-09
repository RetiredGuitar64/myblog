class Docs::ForAdvancedRubyists::Block < DocAction
  get "/docs/for_advanced_rubyists/block" do
    html Docs::ForAdvancedRubyists::BlockPage
  end
end
