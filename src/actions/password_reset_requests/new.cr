class PasswordResetRequests::New < BrowserAction
  include Auth::RedirectSignedInUsers

  get "/password_reset_requests/new" do
    html PasswordResetRequests::NewPage, operation: RequestPasswordReset.new
  end
end
