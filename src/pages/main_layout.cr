abstract class MainLayout
  include Lucky::HTMLPage
  include PageHelpers
  include PageHelpers::Box

  abstract def content
  abstract def page_title

  needs formatter : Tartrazine::Formatter

  # The default page title. It is passed to `Shared::LayoutHead`.
  #
  # Add a `page_title` method to pages to override it. You can also remove
  # This method so every page is required to have its own page title.
  def page_title
    "Welcome"
  end

  def sub_title
    nil
  end

  def current_path
    context.request.path
  end

  def render
    html_doctype

    html lang: "en", class: "-no-dark-theme" do
      mount Shared::LayoutHead, page_title: page_title

      body "hx-boost": true, style: "padding: 0px;" do
        mount Shared::FlashMessages, context.flash

        header class: "navbar", style: "margin-bottom: 2px;" do
          mount Navbar
        end

        div class: "sidebar-layout fullscreen" do
          header do
            mount Sidebar if current_path.starts_with?("/docs")
          end

          div class: "col-2" do
            main do
              h2 do
                text page_title
                sub_title_tag sub_title if sub_title
              end
              content
              mount Pager
            end

            footer class: "f-row flex-wrap:wrap justify-content:center" do
              mount Footer
            end
          end
        end
      end

      dialog(class: "margin f-col",
        style: "max-width: 100%; width: 30em;
max-height: 100%; height: 40em;
padding-bottom: 0;") do
        label "Search", for: "search-input", class: "titlebar", style: "margin-inline: calc(-1*var(--gap))"

        para do
          input autofocus: "", id: "search-input", class: "block width:100%"
        end

        div role: "listbox", "aria-label": "results", class: "flow-gap padding-inline", style: "overflow-y: auto; margin-inline: calc(-1*var(--gap))" do
        end
      end
    end
  end
end
