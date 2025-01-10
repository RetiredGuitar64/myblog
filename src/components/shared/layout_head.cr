class Shared::LayoutHead < BaseComponent
  needs page_title : String

  def render
    head do
      utf8_charset
      title "Crystal China - #{@page_title}"
      if LuckyEnv.production?
        js_link "https://kit.fontawesome.com/84b6da8eb9.js", crossorigin: "anonymous"
      else
        css_link "/css/all.css"
      end
      css_link asset("css/app.css")
      js_link asset("js/app.js"), defer: "true"

      csrf_meta_tags
      responsive_meta_tag
      # css_link "https://fonts.googleapis.com/icon?family=Material+Icons"

      # css_link "https://fonts.bunny.net/css?family=source-sans-3:400,700|m-plus-code-latin:400,700"

      # Development helper used with the `lucky watch` command.
      # Reloads the browser when files are updated.
      live_reload_connect_tag if LuckyEnv.development?
    end
  end
end
