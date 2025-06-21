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
    raw(MARKDOWN_CACHE.fetch(markdown_path) { markdown File.read(markdown_path) })
  end

  def page_title
    PAGINATION_RELATION_MAPPING.dig?(current_path, :title) || "文档"
  end

  def print_votes
    doc = DocQuery.new.path_index(current_path).first?

    return if doc.nil?

    me = current_user

    voted_types = if me.nil?
                    [] of String
                  else
                    VoteQuery.new.user_id(me.id).doc_id(doc.id).map &.vote_type
                  end

    div class: "f-row", style: "margin-bottom: 0px;" do
      mount(
        Shared::VoteButton,
        votes: Hash(String, Int32).from_json(doc.votes.to_json),
        doc_id: doc.id,
        current_user: me,
        voted_types: voted_types
      )
    end
  end

  def print_doc_date
    doc = DocQuery.new.path_index(current_path).first?

    return "" if doc.nil?

    timestamp = JSON.parse(File.read("dist/mix-manifest.json"))["/docs/markdowns_timestamps.yml"]
    timestamp = "dist#{timestamp}"

    if File.exists?(timestamp)
      YAML.parse(File.read(timestamp))[markdown_path]?.try do |date|
        return <<-HEREDOC
<blockquote>
创建于：#{doc.created_at.to_s("%Y年%m月%d日")}    最后编辑于: #{Time.unix(date.as_i64).to_local.to_s("%Y年%m月%d日")}
</blockquote>
HEREDOC
      end
    end

    ""
  end

  def sub_title
    PAGINATION_RELATION_MAPPING.dig?(current_path, :sub_title)
  end

  def render
    html_doctype

    html lang: "en", class: "-no-dark-theme" do
      mount Shared::LayoutHead, page_title: page_title

      body hx_boost: true, style: "padding: 0px;" do
        mount Navbar, current_user: current_user

        div class: "sidebar-layout fullscreen" do
          header id: "sidebar" do
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

              div class: "f-row justify-content:space-between" do
                raw print_doc_date
                print_votes
              end

              content

              mount Pager

              div class: "<h5> f-row justify-content:center", style: "color: #BEBEBE" do
                text "欢迎在评论区留下你的见解、问题或建议"
              end

              div id: "form_with_replies" do
                mount Docs::Form, current_user: current_user

                show_replies_when_revealed
              end

              footer class: "f-row flex-wrap:wrap justify-content:center" do
                mount Footer
              end
            end
          end

          mount Shared::Common
        end
      end

      doc_search_dialog
    end
  end

  private def show_replies_when_revealed
    div id: "replies", hx_get: current_reply_path, hx_trigger: "revealed" do
      mount Shared::Spinner, text: "正在读取评论..."
    end
  end

  private def doc_search_dialog
    dialog(
      class: "margin f-col",
      style: "max-width: 100%; width: 30em;
max-height: 100%; height: 40em;
padding-bottom: 0;") do
      label "注意：中文搜索结果通常不准确, 请使用英文关键字！", for: "search-input", class: "titlebar", style: "margin-inline: calc(-1*var(--gap))"

      div class: "stork-wrapper-flat" do
        input data_stork: "docs", class: "stork-input", id: "search-input"
        div data_stork: "docs-output", class: "stork-output"
      end
    end
  end
end
