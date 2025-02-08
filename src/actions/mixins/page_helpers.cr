require "ecr"

module PageHelpers
  PAGE_URL_MAPPING = {
    "/docs"                       => {name: "前言", next_page: ["简介", "/docs/introduction"], parent: "root"},
    "/docs/introduction"          => {name: "简介", prev_page: ["前言", "/docs"], next_page: ["写给 Rubyists", "/docs/for_advanced_rubyists"], parent: "root"},
    "/docs/for_advanced_rubyists" => {name: "写给 Rubyists", prev_page: ["简介", "/docs/introduction"], next_page: ["安装", "/docs/install"], parent: "root"},
    "/docs/install"               => {name: "安装", prev_page: ["写给 Rubyists", "/docs/for_advanced_rubyists"], next_page: ["包管理", "/docs/package_manager"], parent: "root"},
    "/docs/package_manager"       => {name: "包管理", prev_page: ["安装", "/docs/install"], next_page: ["基础知识", "/docs/basic"], parent: "/docs/install"},
    "/docs/basic"                 => {name: "基础知识", prev_page: ["包管理", "/docs/package_manager"], next_page: ["下一个", "/docs/basic"], parent: "root"},
  }

  record(
    PageMapping,
    name : String,
    path : String,
    next_page : Array(String)?,
    prev_page : Array(String)?,
    parent : String = "root",
    child = [] of PageMapping
  )

  SIDEBAR_LINKS = {} of String => PageMapping

  PAGE_URL_MAPPING.each do |k, v|
    parent = v[:parent]

    if parent == "root"
      SIDEBAR_LINKS[k] = PageMapping.new(
        name: v[:name],
        path: k,
        next_page: v[:next_page]?,
        prev_page: v[:prev_page]?
      )
    else
      if SIDEBAR_LINKS.has_key?(parent)
        SIDEBAR_LINKS[parent].child << PageMapping.new(
          name: v[:name],
          path: k,
          next_page: v[:next_page]?,
          prev_page: v[:prev_page]?
        )
      end
    end
  end

  MARKDOWN_OPTIONS = Markd::Options.new(gfm: true)

  def markdown(text)
    # 这里替换文本是 fcitx 开启中文，输入的 ^，被替换的字符是 中文全角空格，U+3000
    # 主要，输入的 …… 是双字节，删除调整时，可能存在半个字符，…，会被替换为空。
    raw Markd.to_html(
      text.gsub(/……(?=……| )/, "‏　").gsub("…", ""),
      formatter: formatter,
      options: MARKDOWN_OPTIONS
    )
  end
end
