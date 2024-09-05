class CreatePgroongaExtension::V20240905170051 < Avram::Migrator::Migration::V1
  def migrate
    execute <<-'HEREDOC'
CREATE EXTENSION IF NOT EXISTS pgroonga;
HEREDOC
  end

  def rollback
    execute <<-'HEREDOC'
DROP EXTENSION IF EXISTS pgroonga;
HEREDOC
  end
end
