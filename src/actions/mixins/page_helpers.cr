require "autolink"
require "common_marker"

module PageHelpers
  PAGE_URL_MAPPING = {
    "/docs" => {name: "前言", next_page: ["简介", "/docs/introduction"], parent: "root"},

    "/docs/introduction" => {name: "简介", next_page: ["下一个", "/docs/introduction"], prev_page: ["前言", "/docs"], parent: "root"},
    "/docs/test"         => {name: "测试", next_page: ["下一个", "/docs/introduction"], prev_page: ["前言", "/docs"], parent: "/docs/introduction"},
    "/docs/test1"        => {name: "测试1", next_page: ["下一个", "/docs/introduction"], prev_page: ["前言", "/docs"], parent: "/docs/introduction"},
    "/docs/test2"        => {name: "测试2", next_page: ["下一个", "/docs/introduction"], prev_page: ["前言", "/docs"], parent: "/docs"},
  }

  record PageMapping, name : String, path : String, next_page : Array(String)?, prev_page : Array(String)?, parent : String = "root", child = [] of PageMapping

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

  def para_text(para, *, autolink = false)
    para = Autolink.auto_link(para) if autolink

    para do
      text para
    end
  end

  def sub_title_tag(msg)
    if msg
      tag "sub-title" do
        text msg
      end
    end
  end

  def markdown(text)
    md = CommonMarker.new(
      text,
      options: ["unsafe"],
      extensions: ["table", "strikethrough", "autolink", "tagfilter", "tasklist"]
    )
    raw md.to_html
  end
end
