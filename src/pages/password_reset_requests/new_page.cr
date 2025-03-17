class PasswordResetRequests::NewPage < AuthLayout
  needs operation : RequestPasswordReset

  def content
    h1 "重置你的密码"
    render_form(@operation)
  end

  private def render_form(op)
    form_for PasswordResetRequests::Create do
      mount Shared::Field, attribute: op.email, label_text: "电子邮件", &.email_input
      submit "重置", flow_id: "request-password-reset-button"
    end
  end
end
