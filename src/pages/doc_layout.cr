require "../../tasks/db/seed/hourly_availability"

abstract class DocLayout
  include Lucky::HTMLPage
  include PageHelpers

  needs current_user : User?
  needs formatter : Tartrazine::Formatter

  def markdown_path
    name = current_path.sub(%r{/docs/}, "markdowns/")
    "#{name}.md"
  end

  def content
    content = File.read(markdown_path)

    regex = /TableScheduler20250703 year: (\d+), month: (\d+)/

    if content.match(regex)
      year = $1.to_i
      month = $2.to_i

      Db::Seed::HourlyAvailabilityTask.run(year, month) if HourlyAvailabilityQuery.new.date("#{year}-#{month}-01").none?

      content = content.sub(
        regex,
        TableScheduler.new(year: year, month: month, current_user: current_user).render_to_string
      )
    end

    raw(MARKDOWN_CACHE.fetch(markdown_path) { markdown content })
  end

  def page_title
    PAGINATION_RELATION_MAPPING.dig?(current_path, :title) || "文档"
  end

  def print_votes(doc)
    me = current_user

    voted_types = if me.nil?
                    [] of String
                  else
                    VoteQuery.new.user_id(me.id).doc_id(doc.id).map &.vote_type
                  end

    div class: "flex flex-row mb-0" do
      mount(
        Shared::VoteButton,
        votes: Hash(String, Int32).from_json(doc.votes.to_json),
        doc_id: doc.id,
        current_user: me,
        voted_types: voted_types
      )
    end
  end

  def print_doc_info(doc)
    doc_info = "创建于：#{doc.created_at.to_s("%Y年%m月%d日")}"

    timestamp = JSON.parse(File.read("dist/mix-manifest.json"))["/assets/docs/markdowns_timestamps.yml"]?
    if timestamp
      timestamp_path = "dist#{timestamp}"
      if File.exists?(timestamp_path)
        YAML.parse(File.read(timestamp_path))[markdown_path]?.try do |date|
          doc_info += " | 最后编辑于: #{Time.unix(date.as_i64).to_local.to_s("%Y年%m月%d日")}"
        end
      end
    end

    doc_info += " | #{doc.view_count}次阅读" if doc.view_count > 0

    # 原始版本保持不变
    "<div class='bg-white/30 p-2 rounded-lg mb-4 text-sm text-gray-600 italic'>#{doc_info}</div>"
  end

  def sub_title
    PAGINATION_RELATION_MAPPING.dig?(current_path, :sub_title)
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body class: "max-h-screen bg-fixed bg-gradient-to-br from-gray-200 via-blue-300 to-purple-400", "hx-boost": "true" do
        div class: "flex flex-col min-h-screen" do
          mount Navbar, current_user: current_user

          div class: "flex flex-1" do
            aside id: "sidebar", class: "w-64" do
              mount Sidebar, current_user: current_user
            end

            main class: "flex-1 p-8" do
              # 修改5：仅在此处修改容器样式
              div class: "max-w-5xl mx-auto bg-white/40 rounded-lg shadow-md p-8" do
                header class: "mb-6" do
                  h1 class: "text-3xl font-bold text-gray-800" do
                    text page_title
                    if (msg = sub_title)
                      span class: "block text-lg text-gray-600 mt-1" do
                        text msg
                      end
                    end
                  end
                end

                div class: "flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8" do
                  doc = find_or_create_doc
                  raw print_doc_info(doc)
                  print_votes(doc)
                end

                # 修改3：仅在此处修改字体大小
                article class: "prose max-w-none text-lg" do
                  content
                end

                footer class: "mt-8 pt-6 border-t border-gray-200" do
                  mount Pager
                end

                div class: "text-center text-gray-500 my-8 italic" do
                  text "欢迎在评论区留下你的见解、问题或建议"
                end

                div id: "form_with_replies", class: "mt-8" do
                  mount ::Docs::ReplyToDocForm, current_user: current_user, doc_path: current_path
                  show_replies_when_revealed
                end

                footer class: "mt-12 pt-6 border-t border-gray-200" do
                  mount Footer, current_user: current_user
                end
              end
            end
          end

          mount Shared::Common, page_title: page_title
          doc_search_dialog
        end
      end
    end
  end

  private def show_replies_when_revealed
    div role: "feed", id: "replies",
      class: "mt-8 p-6 bg-white bg-opacity-70 rounded-lg shadow-sm",
      "hx-get": current_reply_path,
      "hx-trigger": "revealed",
      "hx-swap": "outerHTML" do
      mount Shared::Spinner, text: "正在读取评论..."
    end
  end

  private def doc_search_dialog
    dialog id: "doc_search_dialog",
      class: "p-0 rounded-xl shadow-2xl max-w-full w-[30em] max-h-[90vh] bg-white bg-opacity-95 backdrop-blur-sm" do
      div class: "p-4 border-b border-gray-200 bg-gray-50 rounded-t-xl" do
        h3 class: "text-lg font-medium text-gray-900" do
          text "注意：中文搜索结果通常不准确, 请使用英文关键字！"
        end
      end
      div class: "p-4" do
        div class: "stork-wrapper-flat" do
          input data_stork: "docs",
            class: "stork-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500",
            id: "search-input"
          div data_stork: "docs-output", class: "stork-output mt-3"
        end
      end
    end
  end

  private def find_or_create_doc
    doc = DocQuery.new.path_index(current_path).first?
    doc = SaveDoc.create!(path_index: current_path) if doc.nil?
    doc
  end
end