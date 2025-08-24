class PasswordResetRequests::NewPage < AuthLayout
  needs operation : RequestPasswordReset

  def content
    div style: "height: 80vh;", class: "flex justify-center items-center" do
      figure do
        # 密码重置请求框
        div class: "bg-white/40 rounded-xl shadow-md p-6 border border-gray-200/50" do
          h1 class: "text-xl font-bold text-gray-800 text-center mb-6" do
            text "重置你的密码"
          end
          
          render_form(@operation)
        end
      end
    end
  end

  private def render_form(op)
    form_for PasswordResetRequests::Create do
      # 邮箱输入
      div class: "mb-6" do
        mount Shared::Field, attribute: op.email, label_text: "电子邮件", &.email_input(autofocus: "true")
      end

      # 重置按钮
      div class: "text-center" do
        submit "发送重置邮件", 
          flow_id: "request-password-reset-button",
          class: "px-8 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors"
      end
    end
  end
end
