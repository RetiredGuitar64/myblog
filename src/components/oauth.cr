class Component::OAuth < BaseComponent
  def render
    figure class: "flex flex-col items-center space-y-4" do
      # 标题
      h2 class: "mb-4 text-xl font-bold text-center text-gray-800" do
        text "使用 OAuth 登录"
      end

      # Google 按钮
      para do
        link to: SignUps::Oauth::New.with(provider: "google"), 
             hx_boost: "false",
             class: "inline-flex items-center py-2 px-6 rounded-full border border-gray-200 shadow-sm transition-all duration-200 hover:shadow-md bg-white/50 hover:bg-white/80" do
          # Google 图标
          span class: "flex justify-center items-center mr-2 w-5 h-5 bg-white rounded-full" do
            text "G"
          end
          text "Google"
        end
      end

      # Github 按钮
      para do
        link to: SignUps::Oauth::New.with(provider: "github"), 
             hx_boost: "false",
             class: "inline-flex items-center py-2 px-6 rounded-full border border-gray-200 shadow-sm transition-all duration-200 hover:shadow-md bg-white/50 hover:bg-white/80" do
          # Github 图标
          span class: "flex justify-center items-center mr-2 w-5 h-5 bg-black rounded-full" do
            span class: "text-xs font-bold text-white" do
              text "G"
            end
          end
          text "Github"
        end
      end
    end
  end
end
