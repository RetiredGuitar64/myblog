module PageHelpers
  PAGE_URL_MAPPING = {
    "/docs"              => {name: "前言", next_page: ["简介", "/docs/introduction"], parent: "root"},
    "/docs/introduction" => {name: "简介", prev_page: ["前言", "/docs"], next_page: ["顶级 Scope", "/docs/the_top_level_scope"], parent: "root"},
    "/docs/basic"        => {name: "基础", prev_page: ["简介", "/docs/introduction"], next_page: ["下一个", "/docs/introduction"], parent: "root"},
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

  def sub_title_tag(msg)
    if msg
      tag "sub-title" do
        text msg
      end
    end
  end

  def markdown(text)
    raw Markd.to_html(text, formatter: formatter)
  end
end
