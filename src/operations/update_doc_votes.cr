class UpdateDocVotes < Doc::SaveOperation
  permit_columns votes
end
