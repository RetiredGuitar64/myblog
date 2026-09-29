class Admin::Nodes::New < AdminAction
  get "/admin/nodes/new" do
    html Admin::Nodes::NewPage, operation: SaveNode.new
  end
end
