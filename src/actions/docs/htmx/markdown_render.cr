class Docs::Htmx::MarkdownRender < DocAction
  param content : String

  get "/docs/htmx/markdown_render" do
    sleep 0.5
    return head 400 if content.blank?

    plain_text Markd.to_html(
      content,
      formatter: formatter,
      options: PageHelpers::MARKDOWN_OPTIONS
    )
  end
end
