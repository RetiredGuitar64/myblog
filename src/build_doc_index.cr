require "json"
require "./actions/mixins/page_helpers"
require "compress/gzip"
require "file_utils"

File.open("tmp/index.json", "w") do |file|
  string = JSON.build(file) do |json|
    json.array do
      PageHelpers::PAGINATION_RELATION_MAPPING.each do |k, v|
        json.object do
          json.field "title", v[:title]
          json.field "url", k
          json.field "body", File.read("#{k.sub("/docs/", "markdowns/")}.md")
        end
      end
    end
  end
end

FileUtils.rm_r("public/docs")

system("bin/tinysearch tmp/index.json -p public/docs")

File.open("public/docs/tinysearch_engine.js", "r") do |input_file|
  File.open("public/docs/tinysearch_engine.js.gz", "w") do |output_file|
    Compress::Gzip::Writer.open(output_file) do |gz|
      IO.copy(input_file, gz)
    end
  end
end

File.open("public/docs/tinysearch_engine_bg.wasm", "r") do |input_file|
  File.open("public/docs/tinysearch_engine_bg.wasm.gz", "w") do |output_file|
    Compress::Gzip::Writer.open(output_file) do |gz|
      IO.copy(input_file, gz)
    end
  end
end

File.delete?("public/docs/demo.html")
File.delete?("public/docs/package.json")
File.delete?("public/docs/tinysearch_engine.d.ts")
File.delete?("public/docs/tinysearch_engine_bg.wasm.d.ts")
File.delete?("public/docs/.gitignore")
