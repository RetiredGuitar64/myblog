class Htmx::OnlineUsers < BrowserAction
  include Auth::AllowGuests

  param user_id : Int64?

  patch "/htmx/online_users" do
    me = UserQuery.find(user_id.not_nil!) if user_id

    if me
      ONLINE_USER_COUNTER.write(me.id.to_s, "")
    else
      ONLINE_IP_COUNTER.write(context.request.remote_ip || "0.0.0.0", "")
    end

    plain_text "在线用户 #{ONLINE_USER_COUNTER.keys.size} 人, 游客 #{ONLINE_IP_COUNTER.keys.size} 人"
  end
end
