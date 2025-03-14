class Me::Update < BrowserAction
  put "/me/update" do
    me = current_user

    UpdateUser.update(me, params) do |op, user|
      if op.saved?
        flash.success = "成功"
        redirect Docs::Index
      else
        msg = String.build do |io|
          op.errors.each do |(k, v)|
            io << "#{k} #{v.first}\n"
          end
        end
        flash.failure = msg
        html Me::EditPage, op: op
      end
    end
  end
end
