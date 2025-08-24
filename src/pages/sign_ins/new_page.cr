class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    op = operation
    div style: "height: 80vh;", class: "flex justify-center items-center" do
      figure class: "flex gap-10" do
        # 邮箱登录框
        div class: "bg-white/40 rounded-xl shadow-md p-6 border border-gray-200/50" do
          # 添加标题
          h2 class: "text-xl font-bold text-gray-800 text-center mb-6" do
            text "邮箱登录"
          end
          
          form_for SignIns::Create do
            para class: "mb-4" do
              mount Shared::Field, attribute: op.email, label_text: "电子邮件", &.email_input(autofocus: "true")
            end

            para class: "mb-6" do
              mount Shared::Field, attribute: op.password, label_text: "密码", &.password_input
            end

            # 使用 flex 布局确保按钮在同一行
            div class: "flex items-center justify-between" do
              strong do
                submit "登录", 
                  type: "submit", 
                  flow_id: "sign-in-button",
                  class: "px-10 py-3 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors text-base"  # 增大登录按钮
              end

              strong do
                link "重置密码", 
                  to: PasswordResetRequests::New,
                  class: "px-2 py-1 bg-gray-500 text-white rounded-full hover:bg-gray-600 transition-colors text-sm"  # 减小重置密码按钮
              end
            end
          end
        end

        # OAuth 框
        div class: "bg-white/40 rounded-xl shadow-md px-6 py-10 border border-gray-200/50 self-center" do
          mount Component::OAuth
        end
      end
    end
  end
end
