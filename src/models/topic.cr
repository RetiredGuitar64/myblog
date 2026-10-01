class Topic < BaseModel
  include Avram::SoftDelete::Model

  table do
    belongs_to user : User
    belongs_to node : Node
    has_one comment_thread : CommentThread?

    column title : String
    column content : String
    column edited_at : Time?
    column soft_deleted_at : Time?
  end
end
