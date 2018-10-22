# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_action :require_login, except: [:index, :login, :new, :create]
  
  def index
    session[:referer_url] = request.referer
  end
  
  def login
    # =================================================================
    #                          入力値の空チェック
    # ============================== start ============================
    params_check = true
    # 空チェック1
    if (params[:user_id] == "")
      flash.now[:user_id] = "ユーザIDを入力してください"
      params_check = false
    end
    
    # 空チェック2
    if (params[:password] == "")
      flash.now[:password] = "パスワードを入力してください"
      params_check = false
    end
    # =============================== end =============================
    
    
    # =================================================================
    #                            ログイン処理
    # ============================== start ============================
    if (params_check == true)
      user = User.find_by(user_id: params[:user_id])
      if (user && user.authenticate(params[:password]))
        # ログイン成功
        session[:user_id] = user.user_id
        login_success = true
      elsif (user == nil)
        # ユーザIDの入力が間違っている場合
        flash.now[:user_id] = "ユーザIDが存在しません"
        login_success = false
      else
        # パスワードが間違っている場合
        flash.now[:passowrd] = "パスワードが間違っております"
        login_success = false
      end
    end
    # =============================== end =============================
    
    if ((params_check == true) && (login_success == true))
      redirect_to(session[:referer_url], notice: "ログインしました")
      
      session[:referer_url] = nil
    else
      # ユーザIDについては、既に入力してある値を表示
      # （パスワードについては、再度入力を行う）
      @user_id = params[:user_id]
      
      render("index")
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to(root_path, notice: "ログアウトしました")
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find_by(user_id: session[:user_id])
    
    # 新しいパスワードをユーザに設定させるため
    #@user.password = ""
    #@user.password_confirmation = ""
  end
  
  def create
    @user = User.new(user_params)
    
    if (@user.save)
      session[:user_id] = @user.user_id
      redirect_to(root_path, notice: "アカウントを作成し、ログインしました")
    else
      render("new")
    end
  end
  
  def update
    @user = User.find_by(user_id: session[:user_id])
    
    if @user.update(user_params)
      redirect_to("/users/#{@user.user_id}", notice:"パスワードを変更しました")
    else
      render("edit")
    end
  end
  
  def show
    @user = User.find_by(user_id: session[:user_id])
  end
  
  def delete_confirm
    @user = User.find_by(user_id: session[:user_id])
  end
  
  def destroy
    @user = User.find_by(user_id: session[:user_id])
    
    @user.destroy
    
    session[:user_id] = nil
    redirect_to(root_path, notice:"アカウントを削除しました")
  end
  
  def user_params
    params.require(:user).permit(:user_id, :password, :password_confirmation)
  end
end
