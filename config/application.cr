# This file may be used for custom Application configurations.
# It will be loaded before other config files.
#
# Read more on configuration:
#   https://luckyframework.org/guides/getting-started/configuration#configuring-your-own-code

# Use this code as an example:
#
# ```
# module Application
#   Habitat.create do
#     setting support_email : String
#     setting lock_with_basic_auth : Bool
#   end
# end
#
# Application.configure do |settings|
#   settings.support_email = "support@myapp.io"
#   settings.lock_with_basic_auth = LuckyEnv.staging?
# end
#
# # In your application, call
# # `Application.settings.support_email` anywhere you need it.
# ```

# For htmx hx-boost: true on the body work correct.
Lucky::Redirectable.configure do |config|
  config.redirect_status = 303
end

# Cache 默认是开启压缩的。
CACHE_STORE = if LuckyEnv.production?
                Cache::MemoryStore(String, String)
              else
                Cache::NullStore(String, String)
              end

CAPTCHA_CACHE       = Cache::MemoryStore(String, String).new(expires_in: 1.minute)
MARKDOWN_CACHE      = CACHE_STORE.new(expires_in: 1.day)
ONLINE_USER_COUNTER = CACHE_STORE.new(expires_in: 3.minutes)
ONLINE_IP_COUNTER   = CACHE_STORE.new(expires_in: 3.minutes)

# upload image into freeimage.host API key.
FREEIMAGE_HOST_API_KEY = ENV["FREEIMAGE_HOST_API_KEY"]? || "fake_key"
