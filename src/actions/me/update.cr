class Me::Update < BrowserAction
  put "/me/update" do
    me = current_user

    UpdateUser.update(me, params) do |op, user|
      if op.saved?
        flash.success = "更新成功！"
        redirect Docs::Index
      else
        build_failed_flash(op)
        html Me::EditPage, op: op
      end
    end
  end
end
