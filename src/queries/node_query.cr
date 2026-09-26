class NodeQuery < Node::BaseQuery
  def sorted
    order_by(:position, :desc).order_by(:name, :asc)
  end
end
