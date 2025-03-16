class PasswordResets::NewPage < AuthLayout
  needs operation : ResetPassword
  needs user_id : Int64

  def content
    h1 "重置你的密码"
    render_password_reset_form(@operation)
  end

  private def render_password_reset_form(op)
    form_for PasswordResets::Create.with(@user_id) do
      mount Shared::Field, attribute: op.password, label_text: "密码", &.password_input(autofocus: "true")
      mount Shared::Field, attribute: op.password_confirmation, label_text: "确认密码", &.password_input

      submit "更新", flow_id: "update-password-button"
    end
  end
end
