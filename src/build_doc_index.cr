require "./actions/mixins/page_helpers"

original_size = PageHelpers::PAGINATION_URLS.size
new_size = PageHelpers::PAGINATION_URLS.uniq.size

if original_size != new_size
  abort "duplicated pages for doc, exit!"
end

system("cd public && git clean -fdxq")

str = String.build do |io|
  io << "[input]\n"
  io << %(base_directory = "markdowns"\n)
  io << "files = [\n"
  PageHelpers::PAGINATION_RELATION_MAPPING.each do |k, v|
    markdown = "#{k.sub("/docs/", "")}.md"
    io << %(    {path = "#{markdown}", url = "#{k}", title = "#{v[:title]}"},\n)
  end
  io << "]"
end

File.write("tmp/index.toml", str)

system("bin/stork build --input tmp/index.toml --output public/docs/index.st")
