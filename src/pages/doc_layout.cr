abstract class DocLayout
  include Lucky::HTMLPage
  include PageHelpers

  # 'needs current_user : User' makes it so that the current_user
  # is always required for pages using MainLayout
  needs current_user : User?
  needs formatter : Tartrazine::Formatter

  macro markdown_path
    {%
      class_name = @type
        .name
        .stringify
        .underscore
        .gsub(/_page$/, "")
        .gsub(/docs::/, "markdowns/")
        .gsub(/::/, "/")
    %}

    "{{class_name.id}}.md"
  end

  def content
    markdown File.read(markdown_path)
  end

  abstract def page_title

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
        script type: "module" do
          raw <<-'HEREDOC'
import { search, default as wasminit } from '/docs/tinysearch_engine.js';
window.search = search;
async function run() {
    await wasminit('/docs/tinysearch_engine_bg.wasm');
}
run();
HEREDOC
        end

        header class: "navbar", style: "margin-bottom: 2px;" do
          mount Navbar, current_user: current_user
        end

        div class: "f-row justify-content:end" do
          mount Shared::FlashMessages, context.flash
        end

        div class: "sidebar-layout fullscreen" do
          header do
            mount Sidebar, current_user: current_user
          end

          div do
            main style: "--density: 0.6" do
              h1 do
                text page_title
                if (msg = sub_title)
                  tag "sub-title" do
                    text msg
                  end
                end
              end

              hr "aria-orientation": "horizontal"

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
          input type: "text", autofocus: "", id: "search-input", class: "block width:100%"
        end

        # div role: "listbox", "aria-label": "results", class: "flow-gap padding-inline", style: "overflow-y: auto; margin-inline: calc(-1*var(--gap))" do
        # end
        ul id: "results"
      end
    end
  end
end
