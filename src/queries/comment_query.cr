class CommentQuery < Comment::BaseQuery
  include Avram::SoftDelete::Query

  def initialize
    defaults &.only_kept
  end
end
