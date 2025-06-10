class Docs::Concurrency < DocAction
  get "/docs/concurrency" do
    html Docs::ConcurrencyPage
  end
end
