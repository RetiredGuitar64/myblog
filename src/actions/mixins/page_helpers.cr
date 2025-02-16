require "ecr"

module PageHelpers
  PAGINATION_RELATION_MAPPING = {
    "/docs/index"                                    => {title: "前言", sub_title: "写在开始之前", parent: "root"},
    "/docs/introduction"                             => {title: "简介", sub_title: "", parent: "root"},
    "/docs/install"                                  => {title: "安装", sub_title: "", parent: "root"},
    "/docs/package_manager"                          => {title: "包管理", sub_title: "shards 命令", parent: "/docs/install"},
    "/docs/for_advanced_rubyists"                    => {title: "写给 Rubyists", sub_title: "分类讨论 Crystal 和 Ruby 的异同", parent: "root"},
    "/docs/for_advanced_rubyists/types"              => {title: "类型", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/methods"            => {title: "方法", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/miscs"              => {title: "杂项", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/migrate_to_crystal" => {title: "迁移 Ruby 代码到 Crystal", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/basic"                                    => {title: "基础知识", sub_title: "一些基础知识的简单总结", parent: "root"},
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
        name: v[:title],
        path: k,
        next_page: v[:next_page]?,
        prev_page: v[:prev_page]?
      )
    else
      if SIDEBAR_LINKS.has_key?(parent)
        SIDEBAR_LINKS[parent].child << PageMapping.new(
          name: v[:title],
          path: k,
          next_page: v[:next_page]?,
          prev_page: v[:prev_page]?
        )
      end
    end
  end

  MARKDOWN_OPTIONS = Markd::Options.new(gfm: true, toc: true)

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
