class UpdateReplyVotes < Reply::SaveOperation
  permit_columns votes
end
