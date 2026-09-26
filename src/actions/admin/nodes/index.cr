class Admin::Nodes::Index < AdminAction
  get "/admin/nodes" do
    nodes = NodeQuery.new.sorted.results

    html Admin::Nodes::IndexPage, nodes: nodes
  end
end
