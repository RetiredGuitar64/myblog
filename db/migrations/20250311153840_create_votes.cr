class CreateVotes::V20250311153840 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Vote) do
      primary_key id : Int64
      add vote_type : String
      add_belongs_to user : User, on_delete: :cascade
      add_belongs_to reply : Reply?, on_delete: :cascade
      add_belongs_to doc : Doc?, on_delete: :cascade
      add_timestamps
    end

    create_index table_for(Vote), [:vote_type, :user_id, :reply_id]
    create_index table_for(Vote), [:vote_type, :user_id, :doc_id]
  end

  def rollback
    # drop_index table_for(Vote), [:vote_type, :user_id, :reply_id], if_exists: true
    # drop_index table_for(Vote), [:vote_type, :user_id, :doc_id], if_exists: true
    drop table_for(Vote)
  end
end
