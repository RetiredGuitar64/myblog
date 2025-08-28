class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    op = operation

    div style: "height: 80vh;", class: "flex justify-center items-center" do
      figure class: "flex gap-10" do
        # 邮箱注册框
        div class: "py-6 px-8 rounded-xl border shadow-md bg-white/40 border-gray-200/50" do
          # 添加标题
          h2 class: "mt-2 mb-4 text-xl font-bold text-center text-gray-800" do
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
              div class: "flex gap-4 items-center" do # 使用gap控制间距
                span(
                  id: "signup_captcha",
                  class: "py-1 px-3 whitespace-nowrap bg-gray-100 rounded-lg transition-colors cursor-pointer hover:bg-gray-200",
                  hx_post: Htmx::SignUps::Captcha.path_without_query_params,
                  hx_target: "#signup_captcha",
                  hx_swap: "outerHTML"
                ) do
                  text "点击获取验证码"
                end
                input type: "text", id: "captcha", name: "captcha", flow_id: "captcha", required: "",
                  class: "py-1 px-2 w-24 rounded-lg border border-gray-500" # 固定宽度
              end
              mount Shared::FieldErrors, op.captcha_code
            end

            para class: "mt-3" do
              strong do
                submit "注册", type: "submit", flow_id: "sign-up-button",
                  class: "text-white bg-blue-500 rounded-full transition-colors hover:bg-blue-600" # 调整按钮大小和圆角
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
