class Me::Update < BrowserAction
  put "/me/update" do
    me = current_user

    UpdateUser.update(me, params) do |op, user|
      if op.saved?
        flash.success = "成功"
        redirect Docs::Index
      else
        build_failed_flash(op)
        html Me::EditPage, op: op
      end
    end
  end
end

# 如果有改动，就新增一条，等待处理。
# 如果之前还有等待处理，不用管，继续新增等待处理
# 如果之前是已经处理，还是新增等待处理。
# 真正处理时，实际步骤是：将所有等待处理改为已处理，但是实际只执行最后一条。

# - 已处理，未处理，等待处理

# 1. 如果前一条已经处理，这一条设为等待处理。
# 2. 如果前一条等待处理，这一条也是等待处理。
# 3. 如果恰一条是等待处理，
