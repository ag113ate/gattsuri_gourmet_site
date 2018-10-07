class ReviewsController < ApplicationController
  def new
    @store = Store.find_by(store_id: params[:id])
    @input_review = InputReview.new
    
  end

  def create
    store = Store.find_by(store_id: params[:id])
    
    input_review = InputReview.new(input_review_params)
    
    # =================================================
    #                 投稿IDの設定
    # =================================================
    vote_id = 0
    random = Random.new(88)
    
    # 既存のレコードの投稿IDと重複しない乱数値を取得
    loop do 
      vote_id = random.rand(10000000)
      record = Review.find_by(vote_id: vote_id)
      if (record == nil)
        break
      end
    end
    
    input_review.vote_id = vote_id
    # =================================================
    
    # ファイル形式を取得
    file_exts = [".jpg", ".jpeg", ".gif", ".png"]
    target_ext = file_exts.each do |file_ext| 
      if (input_review.image_url.match(/#{file_ext}$/) != nil)
        break file_ext
      end
    end
    
    # お店画像フォルダへ保存するファイル名を設定
    dst_img_file_name = "#{store.store_id}_#{input_review.vote_id}#{target_ext}"
    input_review.change_name = dst_img_file_name
    
    # DBへ格納
    input_review.save
    
    # お店画像フォルダへ画像をコピー
    dst_path = "./app/assets/images/store_img/#{dst_img_file_name}"
    FileUtils.cp("./public/#{input_review.image_url}", dst_path)
    
    # ===========================================
    #         Reviewモデルのレコードを作成
    # ===========================================
    review = Review.new
    
    review.vote_id     = input_review.vote_id
    review.user_id     = session[:use_id]
    review.store_id    = store.store_id
    review.menu_name   = input_review.menu_name
    review.comment     = input_review.comment
    review.total_score = input_review.total_score
    review.update_date = input_review.updated_at
    review.updated_at   = input_review.updated_at
    
    review.save
    # ===========================================
    
    # ===========================================
    #       FoodImageモデルのレコードを作成
    # ===========================================
    food_image = FoodImage.new
    
    food_image.store_id = store.store_id
    food_image.vote_id = input_review.vote_id
    food_image.image_url = dst_img_file_name
    
    food_image.save
    # ===========================================
    
    # review = store.reviews.new(review_params)
    # review.vote_id = 108382
    
#    review.menu_name = params[:review][:menu_name]
#                       params[:reserve_list][:name]
#    review.total_score = params[:review][:total_score]
    
#    food_image = FoodImage.new
    
#    food_image.image_url = params[:review][:image_url]
    
#    review.save
#    food_image.save
#    review.save

  end

  def show
    @store = Store.find_by(store_id: params[:id])
  end

  def edit
  end

  def delete
  end
  
  def input_review_params
    params.require(:input_review).permit(:vote_id, :menu_name, :comment, :total_score, :image)
  end
end
