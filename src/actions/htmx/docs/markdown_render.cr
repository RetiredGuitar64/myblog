class Htmx::Docs::MarkdownRender < DocAction
  param content : String

  put "/htmx/docs/markdown_render" do
    return head 401 if current_user.nil?
    return head 400 if content.blank?

    plain_text Markd.to_html(
      content,
      formatter: formatter,
      options: PageHelpers::MARKDOWN_OPTIONS
    )
  end
end
