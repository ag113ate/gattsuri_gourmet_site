class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logined?
    if session[:user_id]
      return true
    else
      return false
    end
  end
  
  def get_img
    img_record = FoodImage.find(params[:id])

    open(img_record.image_url) do |img|
      magick_img = MiniMagick::Image.read(img.read)
      magick_img.resize "!256x256"

      send_data(magick_img.to_blob, dsposition: "inline", type: "image/png")
    end
  end
  
  def require_login
    is_login = logined?
    
    if (is_login != true)
      session[:request_login] = true
      session[:login_complete_link] = request.fullpath
      
      
      # アクションが口コミ投稿の場合は、口コミ投稿後のURLを保持
      path = Rails.application.routes.recognize_path(request.fullpath)
      if ((path[:controller] == "reviews") && (path[:action] == "new"))
        if (request.referer != nil)
          session[:review_complete_link] = URI(request.referer).request_uri
        else
          session[:review_complete_link] = nil
        end
      end
      
      redirect_to("/users", notice: "ログインする必要があります")
    end
  end
  
  helper_method :logined?
end

