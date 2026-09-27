class CreateTopics::V20260908090000 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Node) do
      primary_key id : Int64
      add name : String
      add slug : String
      add summary : String
      add color : String
      add position : Int32, default: 0
      add_timestamps
    end

    create_index table_for(Node), :name, unique: true
    create_index table_for(Node), :slug, unique: true

    execute <<-SQL
      INSERT INTO nodes (name, slug, summary, color, position)
      VALUES ('综合讨论', 'general', 'Crystal 语言及其生态相关的综合讨论。', '#16a34a', 100)
      SQL

    create table_for(Topic) do
      primary_key id : Int64
      add_belongs_to user : User, on_delete: :cascade
      add_belongs_to node : Node, on_delete: :restrict
      add title : String
      add content : String

      # 仅在标题或正文实际改变时写入，用于区分内容编辑和其他数据库更新。
      add edited_at : Time?
      add_timestamps
    end
  end

  def rollback
    drop table_for(Topic)
    drop table_for(Node)
  end
end
