class Docs::ExecutionContext < DocAction
  get "/docs/execution_context" do
    html Docs::ExecutionContextPage
  end
end
