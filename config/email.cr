require "carbon_smtp_adapter"

BaseEmail.configure do |settings|
  if LuckyEnv.production?
    # If you don't need to send emails, set the adapter to DevAdapter instead:
    #
    #   settings.adapter = Carbon::DevAdapter.new
    #
    # If you do need emails, get a key from SendGrid and set an ENV variable
    send_grid_key = send_grid_key_from_env
    settings.adapter = Carbon::SmtpAdapter.new
    Carbon::SmtpAdapter.configure do |settings|
      settings.host = ENV.fetch("CARBON_SMTP_SERVER", "localhost")
      settings.port = ENV["CARBON_SMTP_PORT"]?.try(&.to_i) || 25
      settings.use_tls = true
      settings.username = ENV["CARBON_SMTP_USER"]?
      settings.password = ENV["CARBON_SMTP_PASSWORD"]?
    end
  elsif LuckyEnv.development?
    settings.adapter = Carbon::DevAdapter.new(print_emails: true)
  else
    settings.adapter = Carbon::DevAdapter.new
  end
end

private def send_grid_key_from_env
  ENV["SEND_GRID_KEY"]? || raise_missing_key_message
end

private def raise_missing_key_message
  puts "Missing SEND_GRID_KEY. Set the SEND_GRID_KEY env variable to 'unused' if not sending emails, or set the SEND_GRID_KEY ENV var.".colorize.red
  exit(1)
end
