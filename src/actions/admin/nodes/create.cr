class Admin::Nodes::Create < AdminAction
  post "/admin/nodes" do
    SaveNode.create(params) do |operation, node|
      if node
        flash.success = "节点已创建"

        redirect Admin::Nodes::Index
      else
        build_failed_flash(operation)

        html Admin::Nodes::NewPage, operation: operation
      end
    end
  end
end
