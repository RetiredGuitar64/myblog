class EnablePgroonga::V20260928120000 < Avram::Migrator::Migration::V1
  def migrate
    execute "CREATE EXTENSION IF NOT EXISTS pgroonga;"
  end

  def rollback
    execute "DROP EXTENSION IF EXISTS pgroonga"
  end
end
