class PasswordResets::NewPage < AuthLayout
  needs operation : ResetPassword
  needs user_id : Int64

  def content
    div style: "height: 80vh;", class: "flex justify-center items-center" do
      figure do
        # 密码重置框
        div class: "bg-white/40 rounded-xl shadow-md p-6 border border-gray-200/50" do
          h1 class: "text-xl font-bold text-gray-800 text-center mb-6 mt-2" do
            text "重置你的密码"
          end
          
          render_password_reset_form(@operation)
        end
      end
    end
  end

  private def render_password_reset_form(op)
    form_for PasswordResets::Create.with(@user_id) do
      # 密码输入
      div class: "mb-4" do
        mount Shared::Field, attribute: op.password, label_text: "密码", &.password_input(autofocus: "true")
      end

      # 确认密码
      div class: "mb-6" do
        mount Shared::Field, attribute: op.password_confirmation, label_text: "确认密码", &.password_input
      end

      # 更新按钮
      div class: "text-center" do
        submit "更新", 
          flow_id: "update-password-button",
          class: "px-8 py-2 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors"
      end
    end
  end
end