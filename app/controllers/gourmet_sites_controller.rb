class GourmetSitesController < ApplicationController
  def top
  end

  def disp_search_result
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
end
