class AuthenticationFlow < BaseFlow
  private getter email

  def initialize(@email : String)
  end

  def sign_up(password)
    visit SignUps::New
    fill_form SignUpUser,
      email: email,
      password: password,
      password_confirmation: password
    el("span#signup_captcha").click
    # CAPTCHA_CACHE.keys.size.should eq 1
    # signup_captcha_id = CAPTCHA_CACHE.keys.first
    CAPTCHA_LOCK.synchronize do
      CAPTCHA_CACHE.keys.each do |e|
        CAPTCHA_CACHE.write(e, "foo", expires_in: 10.minutes)
      end
    end
    fill "captcha", with: "foo"
    click "@sign-up-button"
  end

  def sign_out
    visit Me::Show
    sign_out_button.click
  end

  def sign_in(password)
    visit SignIns::New
    fill_form SignInUser,
      email: email,
      password: password
    click "@sign-in-button"
  end

  def should_be_signed_in
    current_page.should have_element("@sign-out-button")
  end

  def should_have_password_error
    current_page.should have_element("div.error", text: "Password is wrong")
  end

  private def sign_out_button
    el("@sign-out-button")
  end

  # NOTE: this is a shim for readability
  private def current_page
    self
  end
end
