class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    op = operation
    div style: "height: 100vh;", class: "f-row justify-content:center align-items:center" do
      figure do
        # figcaption "注册新用户"

        form_for SignUps::Create, class: "table rows" do
          para do
            mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input(autofocus: "true")
          end

          para do
            mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input
          end

          para do
            mount Shared::Field, attribute: op.password_confirmation, label_text: "Confirm Password", &.password_input
          end

          para do
            strong do
              submit "注册", type: "submit", flow_id: "sign-up-button", class: "<button>"
            end
          end
        end
      end
    end
  end
end
