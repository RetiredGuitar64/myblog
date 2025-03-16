class PasswordResetRequests::Create < BrowserAction
  include Auth::RedirectSignedInUsers

  post "/password_reset_requests" do
    puts "1"*100
    RequestPasswordReset.run(params) do |operation, user|
      puts "2"*100
      if user
        puts "3"*100
        x = PasswordResetRequestEmail.new(user).deliver
        pp! x
        flash.success = "You should receive an email on how to reset your password shortly"
        redirect SignIns::New
      else
        html NewPage, operation: operation
      end
    end
  end
end
