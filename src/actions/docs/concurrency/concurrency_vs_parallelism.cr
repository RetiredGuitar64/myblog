class Docs::Concurrency::ConcurrencyVsParallelism < DocAction
  get "/docs/concurrency/concurrency_vs_parallelism" do
    html Docs::Concurrency::ConcurrencyVsParallelismPage
  end
end
