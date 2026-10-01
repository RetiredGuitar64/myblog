class TopicQuery < Topic::BaseQuery
  include Avram::SoftDelete::Query

  def initialize
    defaults &.only_kept
  end
end
