require "../src/app"
require "../tasks/synchronizations/user_to_reply"

CronScheduler.define do
  at("*/2 * * * *") { DB::Synchronizations::UserToReply.new.call }
end
