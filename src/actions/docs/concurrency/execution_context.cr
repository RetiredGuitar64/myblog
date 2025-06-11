class Docs::Concurrency::ExecutionContext < DocAction
  get "/docs/concurrency/execution_context" do
    html Docs::Concurrency::ExecutionContextPage
  end
end
