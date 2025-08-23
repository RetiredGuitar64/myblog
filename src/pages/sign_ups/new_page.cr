class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    op = operation

    div style: "height: 80vh;", class: "flex justify-center items-center" do
      figure class: "flex gap-10" do
        # 邮箱注册框
        div class: "bg-white/40 rounded-xl shadow-md px-8 py-6 border border-gray-200/50" do
          # 添加标题
          h2 class: "text-xl font-bold text-gray-800 text-center mb-4" do
            text "邮箱注册"
          end

          form_for SignUps::Create, class: "table rows" do
            para class: "mb-2" do
              mount Shared::Field, attribute: op.email, label_text: "电子邮件", &.email_input(autofocus: "true", required: "")
            end

            para class: "mb-2" do
              mount Shared::Field, attribute: op.password, label_text: "密码", &.password_input(required: "")
            end

            para class: "mb-4" do
              mount Shared::Field, attribute: op.password_confirmation, label_text: "确认密码", &.password_input(required: "")
            end

            para do
              div class: "flex items-center gap-4" do # 使用gap控制间距
                span(
                  id: "signup_captcha",
                  class: "whitespace-nowrap px-3 py-1 bg-gray-100 rounded-lg cursor-pointer hover:bg-gray-200 transition-colors",
                  hx_post: Htmx::SignUps::Captcha.path_without_query_params,
                  hx_target: "#signup_captcha",
                  hx_swap: "outerHTML"
                ) do
                  text "点击获取验证码"
                end
                input type: "text", id: "captcha", name: "captcha", flow_id: "captcha", required: "",
                  class: "w-24 px-2 py-1 border border-gray-500 rounded-lg" # 固定宽度
              end
              mount Shared::FieldErrors, op.captcha_code
            end

            para class: "mt-3" do
              strong do
                submit "注册", type: "submit", flow_id: "sign-up-button",
                  class: "bg-blue-500 text-white rounded-full hover:bg-blue-600 transition-colors" # 调整按钮大小和圆角
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
