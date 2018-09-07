class GourmetSitesController < ApplicationController
  def top
  end

  def disp_search_result
    @area = params[:area]
    
    @stores = Store.all
  end
end
