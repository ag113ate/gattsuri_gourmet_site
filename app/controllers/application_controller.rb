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
      redirect_to("/users", notice: "ログインする必要があります")
    end
  end
  
  helper_method :logined?
end

