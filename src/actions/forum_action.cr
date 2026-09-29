abstract class ForumAction < BrowserAction
  expose nodes

  private def nodes
    NodeQuery.new.sorted.results
  end
end
