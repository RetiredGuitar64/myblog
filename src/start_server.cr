require "./app"

Habitat.raise_if_missing_settings!

if LuckyEnv.development?
  Avram::Migrator::Runner.new.ensure_migrated!
  Avram::SchemaEnforcer.ensure_correct_column_mappings!
end

app_server = AppServer.new

Signal::INT.trap do
  app_server.close
end

STDERR.puts "Listening on #{ENV["HOST"]}:#{ENV["PORT"]}"
app_server.listen
