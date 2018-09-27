class GourmetSitesController < ApplicationController
  def top
  end

  def disp_search_result
    if (session[:user_id] != nil)
      @user = User.find(session[:user_id])
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
    user = User.find(session[:user_id])
    user.bookmark_stores.create(store_id: params[:id])
    
    @store_id = params[:id]
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def del_bookmark
    user = User.find(session[:user_id])
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
  
end
