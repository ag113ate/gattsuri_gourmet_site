class GourmetSitesController < ApplicationController
  def top
  end

  def disp_search_result
    @area = params[:area]
    
    @stores = Store.where('address LIKE?', "%#{@area}%").limit(10) # 一時的に10件のみ表示
    
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
end
