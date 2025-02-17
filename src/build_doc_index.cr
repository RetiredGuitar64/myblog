require "json"
require "./actions/mixins/page_helpers"

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
