class Component::OAuth < BaseComponent
  def render
    figure class: "f-col justify-content:center align-items:center", style: "margin-left: 50px;" do
      figcaption "使用 OAuth 登录"

      para do
        strong do
          link "Google", to: SignUps::Oauth::New.with(provider: "google"), hx_boost: "false"
        end
      end

      para do
        strong do
          link "Github", to: SignUps::Oauth::New.with(provider: "github"), hx_boost: "false"
        end
      end
      # para do
      #   strong do
      #     link "Twitter", to: SignUps::Oauth::New.with(provider: "twitter"), hx_boost: "false"
      #   end
      # end

      # para do
      #   strong do
      #     link "Facebook", to: SignUps::Oauth::New.with(provider: "facebook"), hx_boost: "false"
      #   end
      # end
    end
  end
end
