require "json"
require "compress/gzip"
require "brotli"
require "./actions/mixins/page_helpers"

original_size = PageHelpers::PAGINATION_URLS.size
new_size = PageHelpers::PAGINATION_URLS.uniq.size

if original_size != new_size
  abort "duplicated pages for doc, exit!"
end

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

Dir.glob(
  "public/docs/index.st",
  "public/docs/stork.wasm",
  "public/svgs/*.svg",
).each do |file|
  File.open(file, "r") do |input_file|
    File.open("#{file}.gz", "w") do |output_file|
      Compress::Gzip::Writer.open(output_file) do |gz|
        IO.copy(input_file, gz)
      end
    end

    input_file.rewind

    File.open("#{file}.br", "w") do |output_file|
      Compress::Brotli::Writer.open(output_file) do |br|
        IO.copy(input_file, br)
      end
    end
  end
end
