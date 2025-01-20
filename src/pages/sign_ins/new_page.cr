class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    op = operation
    div style: "height: 100vh;", class: "f-row justify-content:center align-items:center" do
      figure do
        #   figcaption "登录"

        form_for SignIns::Create, class: "table rows" do
          para do
            mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input(autofocus: "true")
          end

          para do
            mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input
          end

          para do
            strong do
              submit "登录", type: "submit", flow_id: "sign-in-button", class: "<button>"
            end

            strong do
              link "重置密码", to: PasswordResetRequests::New, class: "<button>"
            end
          end
        end
      end
    end
  end
end
