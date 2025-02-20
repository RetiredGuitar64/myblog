require "json"
require "./actions/mixins/page_helpers"
require "compress/gzip"
require "brotli"
require "file_utils"

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

if !Process.find_executable("wasm-pack")
  abort "Install wasm-pack is required!
Try: pacman -S wasm-pack if you use Arch Linux.
"
end

system("bin/stork build --input tmp/index.toml --output public/docs/index.st")

File.open("public/docs/stork.js", "r") do |input_file|
  File.open("public/docs/stork.js.gz", "w") do |output_file|
    Compress::Gzip::Writer.open(output_file) do |gz|
      IO.copy(input_file, gz)
    end
  end
end

File.open("public/docs/stork.js", "r") do |input_file|
  File.open("public/docs/stork.js.br", "w") do |output_file|
    Compress::Brotli::Writer.open(output_file) do |br|
      IO.copy(input_file, br)
    end
  end
end

File.open("public/docs/stork.wasm", "r") do |input_file|
  File.open("public/docs/stork.wasm.gz", "w") do |output_file|
    Compress::Gzip::Writer.open(output_file) do |gz|
      IO.copy(input_file, gz)
    end
  end
end

File.open("public/docs/stork.wasm", "r") do |input_file|
  File.open("public/docs/stork.wasm.br", "w") do |output_file|
    Compress::Brotli::Writer.open(output_file) do |br|
      IO.copy(input_file, br)
    end
  end
end

File.open("public/docs/index.st", "r") do |input_file|
  File.open("public/docs/index.st.gz", "w") do |output_file|
    Compress::Gzip::Writer.open(output_file) do |gz|
      IO.copy(input_file, gz)
    end
  end
end

File.open("public/docs/index.st", "r") do |input_file|
  File.open("public/docs/index.st.br", "w") do |output_file|
    Compress::Brotli::Writer.open(output_file) do |br|
      IO.copy(input_file, br)
    end
  end
end
