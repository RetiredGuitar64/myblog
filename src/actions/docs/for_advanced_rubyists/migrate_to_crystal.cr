class Docs::ForAdvancedRubyists::MigrateToCrystal < DocAction
  get "/docs/for_advanced_rubyists/migrate_to_crystal" do
    html Docs::ForAdvancedRubyists::MigrateToCrystalPage
  end
end
