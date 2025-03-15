require "ecr"

module PageHelpers
  PAGINATION_RELATION_MAPPING = {
    "/docs/index"                                    => {title: "前言", sub_title: "写在开始之前", parent: "root"},
    "/docs/introduction"                             => {title: "简介", sub_title: "", parent: "root"},
    "/docs/install"                                  => {title: "安装", sub_title: "", parent: "root"},
    "/docs/package_manager"                          => {title: "包管理", sub_title: "shards 命令", parent: "/docs/install"},
    "/docs/for_advanced_rubyists"                    => {title: "写给 Rubyists", sub_title: "分类讨论 Crystal 和 Ruby 的异同", parent: "root"},
    "/docs/for_advanced_rubyists/type"               => {title: "类型", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/method"             => {title: "方法", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/block"              => {title: "代码块", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/misc"               => {title: "杂项", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/performance"        => {title: "性能因素（WIP）", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/for_advanced_rubyists/migrate_to_crystal" => {title: "迁移 Ruby 代码到 Crystal", sub_title: "", parent: "/docs/for_advanced_rubyists"},
    "/docs/basic"                                    => {title: "基础知识", sub_title: "一些基础知识的简单总结", parent: "root"},
    "/docs/profile"                                  => {title: "查找性能瓶颈 (WIP)", sub_title: "", parent: "root"},
    "/docs/cross_compile"                            => {title: "交叉编译", sub_title: "", parent: "root"},
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
    raw Markd.to_html(
      text,
      formatter: formatter,
      options: MARKDOWN_OPTIONS
    )
  end

  def current_path
    context.request.path
  end

  def current_reply_path
    current_path.sub("/docs", "/docs/htmx/replies")
  end

  def asset_host
    Lucky::Server.settings.asset_host
  end
end
