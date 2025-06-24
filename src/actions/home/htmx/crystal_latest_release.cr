class Home::Htmx::CrystalLatestRelease < BrowserAction
  include Auth::AllowGuests

  get "/htmx/crystal_latest_release" do
    result = <<-'HEREDOC'
<div class="latest-release-info">
      <a href="https://crystal-lang.org/2025/05/12/1.16.3-released/">Latest release: <strong>1.16.3</strong></a>"
</div>
HEREDOC

    res = HTTP::Client.get("https://crystal-lang.org")

    if res.success?
      match_data = res.body.match(%r{<div class="latest-release-info">.+?</div>}m)
      if !match_data.nil?
        result = match_data.to_s.sub(/href="(.+)?"/, "href=\"https://crystal-lang.org\\1\"")
      end
    end

    plain_text result
  end
end
