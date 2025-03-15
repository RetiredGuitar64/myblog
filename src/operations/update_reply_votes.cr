class UpdateReplyVotes < Reply::SaveOperation
  permit_columns votes

  # before_save do
  #   votes.value = votes
  # end
end
