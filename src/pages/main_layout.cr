abstract class MainLayout
  include Lucky::HTMLPage
  include PageHelpers

  needs current_user : User?

  abstract def content

  def page_title
    "首页"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body hx_boost: true do
        div do
          mount Navbar, current_user: current_user

          main do
            content

            footer class: "f-row flex-wrap:wrap justify-content:center" do
              mount Footer
            end
          end
          mount Shared::Common
        end
      end
    end
  end
end
