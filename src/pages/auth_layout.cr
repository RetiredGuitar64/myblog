abstract class AuthLayout
  include Lucky::HTMLPage

  needs current_user : User?

  abstract def content
  abstract def page_title

  # The default page title. It is passed to `Shared::LayoutHead`.
  #
  # Add a `page_title` method to pages to override it. You can also remove
  # This method so every page is required to have its own page title.
  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en", class: "bg-gradient-to-br from-lime-100 to-purple-400 via-sky-300" do
      mount Shared::LayoutHead, page_title: page_title

      body do
        div do
          mount Navbar, current_user: current_user

          main do
            content
          end

          # 页脚区域
          footer class: "mt-auto w-full" do
            div class: "container flex justify-center px-4 mx-auto" do
              div class: "inline-flex flex-col items-center p-4 rounded-full shadow-sm backdrop-blur-2xl bg-white/20" do
                mount Footer, current_user: current_user
              end
            end
          end
          mount Shared::Common, page_title: page_title
        end
      end
    end
  end
end
