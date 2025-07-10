class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    op = operation

    div style: "height: 100vh;", class: "f-row justify-content:center align-items:center" do
      figure do
        form_for SignUps::Create, class: "table rows" do
          para do
            mount Shared::Field, attribute: op.email, label_text: "电子邮件", &.email_input(autofocus: "true", required: "")
          end

          para do
            mount Shared::Field, attribute: op.password, label_text: "密码", &.password_input(required: "")
          end

          para do
            mount Shared::Field, attribute: op.password_confirmation, label_text: "确认密码", &.password_input(required: "")
          end

          para do
            span(
              id: "signup_captcha",
              hx_post: Htmx::SignUps::Captcha.path_without_query_params,
              hx_target: "#signup_captcha",
              hx_swap: "outerHTML"
            ) do
              text "点击获取人机验证码"
            end
            input type: "text", id: "captcha", name: "captcha", required: ""
            mount Shared::FieldErrors, op.captcha
          end

          para do
            strong do
              submit "注册", type: "submit", flow_id: "sign-up-button", class: "<button>"
            end
          end
        end
      end
      mount Component::OAuth
    end
  end
end
