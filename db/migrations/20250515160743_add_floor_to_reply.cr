class AddFloorToReply::V20250515160743 < Avram::Migrator::Migration::V1
  def migrate
    DocQuery.new.each do |doc|
      ReplyQuery.new.doc_id(doc.id).id.asc_order.each_with_index do |reply, i|
        UpdateReplyFloor.update!(reply, floor: i + 1)
      end
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
