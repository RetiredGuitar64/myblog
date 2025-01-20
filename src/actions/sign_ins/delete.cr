class SignIns::Delete < BrowserAction
  delete "/sign_out" do
    sign_out
    flash.success = "取消登录成功"
    redirect to: SignIns::New
  end
end
