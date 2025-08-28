class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    op = operation
    div style: "height: 80vh;", class: "flex justify-center items-center" do
      figure class: "flex gap-10" do
        # 邮箱登录框
        div class: "p-6 rounded-xl border shadow-md bg-white/40 border-gray-200/50" do
          # 添加标题
          h2 class: "mt-2 mb-6 text-xl font-bold text-center text-gray-800" do
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
            div class: "flex justify-between items-center" do
              strong do
                submit "登录",
                  type: "submit",
                  flow_id: "sign-in-button",
                  class: "py-3 px-10 text-base text-white bg-blue-500 rounded-full transition-colors hover:bg-blue-600" # 增大登录按钮
              end

              strong do
                link "重置密码",
                  to: PasswordResetRequests::New,
                  class: "py-1 px-2 text-sm text-white bg-gray-500 rounded-full transition-colors hover:bg-gray-600" # 减小重置密码按钮
              end
            end
          end
        end

        # OAuth 框
        div class: "self-center py-10 px-6 rounded-xl border shadow-md bg-white/40 border-gray-200/50" do
          mount Component::OAuth
        end
      end
    end
  end
end
