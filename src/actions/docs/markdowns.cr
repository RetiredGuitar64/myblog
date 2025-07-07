class Docs::Markdowns < DocAction
  get "/docs/*:doc_name" do
    if PageHelpers::PAGINATION_RELATION_MAPPING[current_path]?
      html Docs::MarkdownsPage
    else
      head 404
    end
  end
end
