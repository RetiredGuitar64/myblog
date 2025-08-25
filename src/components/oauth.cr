class Component::OAuth < BaseComponent
  def render
    figure class: "flex flex-col items-center space-y-4" do
      # 标题
      h2 class: "text-xl font-bold text-gray-800 text-center mb-4" do
        text "使用 OAuth 登录"
      end

      # Google 按钮
      para do
        link to: SignUps::Oauth::New.with(provider: "google"), 
             hx_boost: "false",
             class: "inline-flex items-center px-6 py-2 bg-white/50 rounded-full shadow-sm border border-gray-200 hover:bg-white/80 hover:shadow-md transition-all duration-200" do
          # Google 图标
          span class: "w-5 h-5 bg-white rounded-full mr-2 flex items-center justify-center" do
            text "G"
          end
          text "Google"
        end
      end

      # Github 按钮
      para do
        link to: SignUps::Oauth::New.with(provider: "github"), 
             hx_boost: "false",
             class: "inline-flex items-center px-6 py-2 bg-white/50 rounded-full shadow-sm border border-gray-200 hover:bg-white/80 hover:shadow-md transition-all duration-200" do
          # Github 图标
          span class: "w-5 h-5 bg-black rounded-full mr-2 flex items-center justify-center" do
            span class: "text-white text-xs font-bold" do
              text "G"
            end
          end
          text "Github"
        end
      end
    end
  end
end
