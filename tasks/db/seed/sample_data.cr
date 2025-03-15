require "../../../spec/support/factories/**"
require "timecop"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::Seed::RequiredData` if you need to create data *required* for your
# app to work.
class Db::Seed::SampleData < LuckyTask::Task
  summary "Add sample database records helpful for development"

  def call
    Signal::INT.trap do
      print_exit("\n按下 Ctrl C")
    end

    print "重置所有开发数据？（y/yes 继续）"
    input = gets.try &.rstrip

    print_exit("拒绝执行") unless input.to_s.downcase.in? ["y", "yes"]

    DocQuery.truncate(cascade: true)
    UserQuery.truncate(cascade: true)
    ReplyQuery.truncate(cascade: true)

    me = SignUpUser.create!(
      email: "me@163.com",
      password: "temp1234",
      password_confirmation: "temp1234"
    )

    user1 = SignUpUser.create!(
      email: "user1@163.com",
      password: "temp1234",
      password_confirmation: "temp1234"
    )

    user2 = SignUpUser.create!(
      email: "user2@163.com",
      password: "temp1234",
      password_confirmation: "temp1234"
    )

    docs = PageHelpers::PAGINATION_URLS.sample(3).map do |path|
      SaveDoc.create!(path_index: path)
    end

    docs.each do |doc|
      Timecop.travel(Time.parse_local("2025-01-05 12:33:55", "%F %T"))

      SaveReply.create!(
        doc_id: doc.id,
        user_id: user1.id,
        content: <<-'HEREDOC'
非常感谢分享！这篇文章**非常**好！
尤其是，讲清楚了他们之间的关系。

> References

```crystal
puts "hello"
```
HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-08 20:05:15", "%F %T"))
      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user2.id,
        content: <<-'HEREDOC'
      我希望分享这篇文章到我的站点

      [my site](https://my_site)

      非常感谢！
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-08 21:24:00", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user2.id,
        content: <<-'HEREDOC'
      真的是很不错的网站！
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-09 01:22:34", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user1.id,
        content: <<-'HEREDOC'
      是的，我赞同！
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:22:34", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user1.id,
        content: <<-'HEREDOC'
      我很喜欢这个网站！
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:33:00", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user1.id,
        content: <<-'HEREDOC'
      这个网站的源码在哪里？

      我是否可以在本地部署这个网站？
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:34:02", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user2.id,
        content: <<-'HEREDOC'
      是啊，想不到 Crystal 语言这么好！
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:35:48", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user1.id,
        content: <<-'HEREDOC'
      国内用的不多，连 Ruby 其实都很小众。
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:36:20", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user2.id,
        content: <<-'HEREDOC'
      是啊，如果不是站长推广，国内都没人知道这个程序语言！
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:40:12", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user2.id,
        content: <<-'HEREDOC'
      希望 Crystal 在国内可以越来越好吧，有人用，才有招聘，有招聘，才有更多的人用。
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:42:18", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user1.id,
        content: <<-'HEREDOC'
      是啊，我相信 Crystal 一定会成功的！
      HEREDOC
      )

      Timecop.travel(Time.parse_local("2025-01-10 08:44:00", "%F %T"))

      random_emoji SaveReply.create!(
        doc_id: doc.id,
        user_id: user2.id,
        content: <<-'HEREDOC'
      对，一定会成功！
      HEREDOC
      )
    end

    Timecop.return

    puts "Done adding sample data"
  end

  def print_exit(reason)
    STDERR.puts reason
    STDERR.puts "退出 ..."
    exit
  end

  def random_emoji(reply)
    UpdateReplyVotes.update!(
      reply,
      votes: Reply::Votes.from_json({
        "👍":  [0, 0, 0, 0, 1, 2, 5, 8, rand(10..99), rand(100..300)].sample,
        "👎":  [0, 0, 0, 0, 1, 2, 5, 8, rand(10..99), rand(100..300)].sample,
        "😄":  [0, 0, 0, 0, 1, 2, 5, 8, rand(10..99), rand(100..300)].sample,
        "🎉":  [0, 0, 0, 0, 1, 2, 5, 8, rand(10..99), rand(100..300)].sample,
        "😕":  [0, 0, 0, 0, 1, 2, 5, 8, rand(10..99), rand(100..300)].sample,
        "❤️": [0, 0, 0, 0, 1, 2, 5, 8, rand(10..99), rand(100..300)].sample,
        "👀️": [0, 0, 0, 0, 1, 2, 5, 8, rand(10..99), rand(100..300)].sample,
      }.to_json)
    )
  end
end
