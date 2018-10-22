class GourmetSitesController < ApplicationController
  # ログイン状態でないと、del_bookmarkアクションは実行されないが、
  # 不正アクセスへの対策として、del_bookmarkアクションも対象とする
  before_action :before_ajx_login_check, only: [:add_bookmark, :del_bookmark]
  
  def top
  end
  
  def select_city
    @cities = City.where(pref_code: params[:pref_num])
    
    @select_pref = @cities[0].pref_name
    
    @city_row_cell_num = 5
  end

  def disp_search_result
    # 店舗を検索する地域名を入れていない場合
    if (params[:area] == "")
      flash.now[:area_emp_error_msg] = "入力してください"
      render(action: "top")
    end
    
    if (session[:user_id] != nil)
      @user = User.find_by(user_id: session[:user_id])
    end
    
    @area = params[:area]
    
    @stores = Store.where('address LIKE?', "%#{@area}%").page(params[:page]).per(10)
    @search_count = Store.where('address LIKE?', "%#{@area}%").count()
    
    @hash = Gmaps4rails.build_markers(@stores) do |store, marker|
      marker.lat store.latitude
      marker.lng store.longitude
      marker.infowindow store.name
      
      marker.picture({
        :url => "/assets/raw_meat.png",
        :width => 30,
        :height => 30
      })
    end
  end
  
  def add_bookmark
    user = User.find_by(user_id: session[:user_id])
    user.bookmark_stores.create(store_id: params[:id])
    
    @store_id = params[:id]
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def del_bookmark
    user = User.find_by(user_id: session[:user_id])
    user.bookmark_stores.find_by(store_id: params[:id]).destroy

    @store_id = params[:id]
    
    path = Rails.application.routes.recognize_path(request.referer)
    @action = path[:action]
    
    @bookmark_count = user.bookmark_stores.count

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def before_ajx_login_check
    if (session[:user_id] == nil)
      respond_to do |format|
        format.js{ render :bookmark_request_login}
      end
    end
  end
end
