class Htmx::Captcha < BrowserAction
  include Auth::AllowGuests

  param width : String?
  param height : String?

  post "/signups/htmx/captcha" do
    signup_captcha_id = Random.base58(10)
    cookies.set("signup_captcha_id", signup_captcha_id)
    captcha = CaptchaGenerator.new

    CAPTCHA_CACHE.write(signup_captcha_id, captcha.code)

    plain_text <<-HEREDOC
<span
id="signup_captcha"
hx-post="#{Htmx::Captcha.path}"
hx-target="#signup_captcha"
hx-swap="outerHTML"
>
#{captcha.img_tag(height: "35px")}
</span>
HEREDOC
  end
end
