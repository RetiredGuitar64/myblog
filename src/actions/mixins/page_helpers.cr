require "ecr"

module PageHelpers
  PAGINATION_RELATION_MAPPING = {
    "/docs"                                          => {name: "前言", parent: "root"},
    "/docs/introduction"                             => {name: "简介", parent: "root"},
    "/docs/install"                                  => {name: "安装", parent: "root"},
    "/docs/package_manager"                          => {name: "包管理", parent: "/docs/install"},
    "/docs/for_advanced_rubyists"                    => {name: "写给 Rubyists", parent: "root"},
    "/docs/for_advanced_rubyists/types"              => {name: "类型相关", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/methods"            => {name: "方法相关", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/miscs"              => {name: "杂项", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/migrate_to_crystal" => {name: "迁移 Ruby 代码到 Crystal", parent: "/docs/for_advanced_rubyists"},
    "/docs/basic"                                    => {name: "基础知识", parent: "root"},
  }
  PAGINATION_URLS = PAGINATION_RELATION_MAPPING.keys

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

  PAGINATION_RELATION_MAPPING.each do |k, v|
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
