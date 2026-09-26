class AddNodesToTopics::V20260926130000 < Avram::Migrator::Migration::V1
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

    alter table_for(Topic) do
      add_belongs_to node : Node?, on_delete: :restrict
    end

    execute <<-SQL
      UPDATE topics
      SET node_id = (SELECT id FROM nodes WHERE slug = 'general')
      WHERE node_id IS NULL
      SQL

    execute "ALTER TABLE topics ALTER COLUMN node_id SET NOT NULL"
  end

  def rollback
    alter table_for(Topic) do
      remove_belongs_to :node
    end

    drop table_for(Node)
  end
end
