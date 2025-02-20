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

  def page_title
    PAGINATION_RELATION_MAPPING.dig(current_path, :title) || "首页"
  end

  def sub_title
    PAGINATION_RELATION_MAPPING.dig(current_path, :sub_title)
  end

  def current_path
    context.request.path
  end

  def render
    html_doctype

    html lang: "en", class: "-no-dark-theme" do
      mount Shared::LayoutHead, page_title: page_title

      body "hx-boost": true, style: "padding: 0px;" do
        header class: "navbar", style: "margin-bottom: 2px; margin-top: 0px;" do
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
        label "注意：中文搜索结果通常不准确, 请使用英文关键字！", for: "search-input", class: "titlebar", style: "margin-inline: calc(-1*var(--gap))"

        div class: "stork-wrapper-flat" do
          input data_stork: "docs", class: "stork-input", id: "search-input"
          div data_stork: "docs-output", class: "stork-output"
        end

        js_link "https://assets.crystal-china.org/docs/stork.js"

        script do
          raw <<-'HEREDOC'
              stork.initialize("https://assets.crystal-china.org/docs/stork.wasm");
              stork.register(
                "docs",
                "https://assets.crystal-china.org/docs/index.st"
              );
        HEREDOC
        end
      end
    end
  end
end
