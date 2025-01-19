abstract class AuthLayout
  include Lucky::HTMLPage

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

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body do
        mount Shared::FlashMessages, context.flash

        header class: "navbar", style: "margin-bottom: 2px;" do
          mount Navbar
        end

        main do
          content
        end

        footer class: "f-row flex-wrap:wrap justify-content:center" do
          mount Footer
        end
      end
    end
  end
end
