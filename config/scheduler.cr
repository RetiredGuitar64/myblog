require "../src/app"
require "../tasks/synchronizations/user_to_reply"

CronScheduler.define do
  at("*/2 * * * *") { DB::Synchronizations::UserToReply.new.call }
  # 因为 scheduler 表格会在第 59 分的时候做一个判断，让前一个 hour 变暗，
  # 因此，每个小时整点的时候，必须让 cache 无效
  at("00 * * * * ") { MARKDOWN_CACHE.clear }
end
