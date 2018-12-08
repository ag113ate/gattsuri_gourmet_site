# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_action :require_login, except: [:index, :login, :new, :create]
  
  def index
    # 「口コミを書く(reviews/newアクション)」等で、システムに途中でログインを
    #  要求された場合、ログイン後は本来の遷移先に移動する
    #  例1：末ログイン状態で、「口コミを書く」ボタンをクリック
    #           ⇒　システムにより、ログイン画面が表示される
    #               ログイン後は、「口コミの投稿ページ」へ移動
    #  例2:お店の検索ページを表示中に、ヘッダの「ログイン」ボタンをクリック
    #           ⇒  ログイン画面が表示される
    #               ログイン後は、お店の検索ページへ戻る
    #
    # ※ システムにログインを要求された場合は「session[:request_login] == true」
    #    となっている
    if (session[:request_login] == nil)
      if (request.referer != nil)
        session[:login_complete_link] = URI(request.referer).request_uri
      else
        session[:login_complete_link] = nil
      end
    end
    
    # 「本来の遷移先のURLを設定するか」、あるいは「遷移元のURL」に移動するか
    #  の判断のために使用していたsessionであり、上記で役割は果たしたため、nilを設定
    session[:request_login] = nil
    
    # ログイン画面の「戻る」ボタンのリンク先
    session[:referer_url] = URI(request.referer).request_uri
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
      if (session[:login_complete_link] != nil)
        redirect_to(session[:login_complete_link], notice: "ログインしました")
      else
        redirect_to("/users/#{session[:user_id]}", notice: "ログインしました")
      end
      
      session[:login_complete_link] = nil
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
  end
  
  def create
    @user = User.new(user_params)
    
    is_success_save = @user.save
    
    if (is_success_save && (session[:login_complete_link] != nil))
      session[:user_id] = @user.user_id
      redirect_to(session[:login_complete_link], notice: "アカウントを作成し、ログインしました")
      session[:login_complete_link] = nil
      
    elsif(is_success_save && (session[:login_complete_link] == nil))
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
