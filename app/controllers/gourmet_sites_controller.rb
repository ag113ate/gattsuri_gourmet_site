class GourmetSitesController < ApplicationController
  def top
  end

  def disp_search_result
    @area = params[:area]
    
    @stores = Store.all

    @hash = Gmaps4rails.build_markers(@stores) do |store, marker|
      marker.lat store.latitude
      marker.lng store.longitude
      marker.infowindow store.name
    end
  end
end
