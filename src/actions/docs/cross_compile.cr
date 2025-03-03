class Docs::CrossCompile < DocAction
  get "/docs/cross_compile" do
    html Docs::CrossCompilePage
  end
end
