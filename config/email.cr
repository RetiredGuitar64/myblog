require "carbon_smtp_adapter"

BaseEmail.configure do |settings|
  if LuckyEnv.production?
    settings.adapter = Carbon::SmtpAdapter.new
    Carbon::SmtpAdapter.configure do |settings|
      settings.host = ENV.fetch("CARBON_SMTP_SERVER", "localhost")
      settings.port = ENV["CARBON_SMTP_PORT"]?.try(&.to_i) || 587
      settings.username = ENV["CARBON_SMTP_USER"]?
      settings.password = ENV["CARBON_SMTP_PASSWORD"]?
      settings.use_tls = true
    end
  elsif LuckyEnv.development?
    settings.adapter = Carbon::DevAdapter.new(print_emails: true)
  else
    settings.adapter = Carbon::DevAdapter.new
  end
end
