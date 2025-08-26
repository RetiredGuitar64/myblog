require "ecr"
require "digest/md5"

module PageHelpers
  PAGINATION_RELATION_MAPPING = {
    "/docs/index"                                    => {title: "Self Introduction", sub_title: ""},
    "/docs/first_blog"                               => {title: "First Blog", sub_title: ""},
    "/docs/friends_in_Germen"                        => {title: "德国的朋友", sub_title: "是一对人很好的夫妻"},
    "/docs/7_11_Ben"                                 => {title: "2025_7_11", sub_title: ""},
    "/docs/7_12_Kevin"                               => {title: "2025_7_12", sub_title: ""},
    "/docs/7_17_Fatima"                              => {title: "2025_7_17", sub_title: ""},
    "/docs/7_18_Andrei"                              => {title: "2025_7_18", sub_title: ""},
    "/docs/7_19_Fatima"                              => {title: "2025_7_19", sub_title: ""},
    "/docs/7_27"                                     => {title: "2025_7_27", sub_title: ""},
    "/docs/8_9"                                      => {title: "2025_8_9", sub_title: ""},
    "/docs/8_19_Scott"                                     => {title: "2025_8_19", sub_title: ""},
  }
  PAGINATION_URLS = PAGINATION_RELATION_MAPPING.keys

  record(
    PageMapping,
    name : String,
    path : String,
    parent : String = "root",
    child = [] of PageMapping,
  )

  SIDEBAR_LINKS = {} of String => PageMapping

  PAGINATION_RELATION_MAPPING.each do |k, v|
    parent = v[:parent]? || "root"
    hidden = v[:hidden]?

    if parent == "root"
      SIDEBAR_LINKS[k] = PageMapping.new(
        name: v[:title],
        path: k,
      ) unless hidden == "true"
    else
      if SIDEBAR_LINKS.has_key?(parent)
        SIDEBAR_LINKS[parent].child << PageMapping.new(
          name: v[:title],
          path: k,
        ) unless hidden == "true"
      end
    end
  end

  MARKDOWN_OPTIONS = Markd::Options.new(gfm: true, toc: true)

  def markdown(text) : String
    Markd.to_html(
      text,
      formatter: formatter,
      options: MARKDOWN_OPTIONS
    )
  end

  def current_path
    context.request.path
  end

  def current_reply_path
    current_path.sub("/docs", "/htmx/replies/docs")
  end

  # def asset_host
  #   Lucky::Server.settings.asset_host
  # end

  # def fingerprinted_filename(file_path : String)
  #   return file_path unless LuckyEnv.production?

  #   path = Path[file_path]
  #   basename = path.stem
  #   digest = Digest::MD5.hexdigest(File.read(path))[0..7]

  #   if basename.ends_with? digest
  #     file_path
  #   else
  #     (Path[path.dirname] / "#{basename}-#{digest}#{path.extension}").to_s
  #   end
  # end
end
