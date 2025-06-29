class Shared::Common < BaseComponent
  needs page_title : String

  def render
    input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf", id: "csrf")

    raw <<-HEREDOC
<script>
if (typeof logEvent !== 'undefined') {
  logEvent(analytics, 'page_view', {
    page_path: '#{current_path}',
    page_title: '#{page_title}',
  });
}
</script>
HEREDOC
  end
end
