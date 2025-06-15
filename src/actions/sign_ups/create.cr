class SignUps::Create < BrowserAction
  include Auth::RedirectSignedInUsers

  post "/sign_up" do
    signup_captcha_id = cookies.get?("signup_captcha_id")

    return sign_up(params, "验证码无效") if signup_captcha_id.nil?

    signup_captcha_code = CAPTCHA_CACHE.fetch(signup_captcha_id)

    return sign_up(params, "验证码无效") if signup_captcha_code.nil?

    captcha_input = params.get?(:captcha)

    return sign_up(params, "验证码无效") if captcha_input.nil?

    return sign_up(params, "验证码无效") if captcha_input.downcase != signup_captcha_code.downcase

    sign_up(params, "注册失败", signup_captcha_code)
  end

  def sign_up(params, flash_msg, captcha : String = "")
    SignUpUser.create(params, captcha: captcha) do |operation, user|
      if user
        flash.info = "注册成功"
        sign_in(user)
        redirect to: Home::Index
      else
        flash.failure = flash_msg
        html NewPage, operation: operation
      end
    end
  end
end
