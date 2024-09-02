module App
  VERSION          = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  DEPLOYED_VERSION = {{ `git rev-parse --short HEAD`.chomp.stringify + `crystal eval 'puts Time.local.to_s(" %Y/%m/%d %H:%M:%S")'`.chomp.stringify }}
end

require "./shards"

# Load the asset manifest
Lucky::AssetHelpers.load_manifest "public/mix-manifest.json"

require "../config/server"
require "./app_database"
require "../config/**"
require "./models/base_model"
require "./models/mixins/**"
require "./models/**"
require "./queries/mixins/**"
require "./queries/**"
require "./operations/mixins/**"
require "./operations/**"
require "./serializers/base_serializer"
require "./serializers/**"
require "./actions/mixins/**"
require "./actions/**"
require "./components/base_component"
require "./components/**"
require "./pages/**"
require "./app_server"
