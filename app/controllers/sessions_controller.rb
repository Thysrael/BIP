class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    # 这里更加明显，create 会有一个 params，params 的来历就是 new 填的表单
    user = User.find_by(name: params[:name])
    # try 对于为 nil 的 user，会直接进入 else
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      session[:user_role] = user.role
      # 如果是 Buyer ，就定向到商店，否则定向到 admin 的欢迎界面
      if user.role == "Buyer"
        redirect_to store_index_url
      else
        redirect_to admin_url
      end
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_role] = nil
    redirect_to store_index_url, notice: "Logged out"
  end
end
