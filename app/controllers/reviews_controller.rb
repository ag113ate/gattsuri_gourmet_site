class ReviewsController < ApplicationController
  def new
    @store = Store.find_by(store_id: params[:store_id])
    @input_review = InputReview.new
    
  end

  def create
    @store = Store.find_by(store_id: params[:store_id])
    
    @input_review = InputReview.new(input_review_params)
    
    # =================================================
    #                 投稿IDの設定
    # =================================================
    vote_id = 0
    random = Random.new(88)
    
    # 既存のレコードの投稿IDと重複しない乱数値を取得
    loop do 
      vote_id = random.rand(10000000)
      review_record = Review.find_by(vote_id: vote_id)
      input_review_record = InputReview.find_by(vote_id: vote_id)
      if ((review_record == nil) && (input_review_record == nil))
        break
      end
    end
    
    @input_review.vote_id = vote_id
    # =================================================
    
    @input_review.valid?
    # 「InputReviewモデル」のレコード情報は「Review」モデルに、全て含まれている
    #  想定だが、エラーによる処理の途中終了などに備え、両モデルに対してチェックを行う
    if ((@input_review.errors["image"].blank? == true) \
        && (@input_review.image.present? == true))
      # ファイル形式を取得
      file_exts = [".jpg", ".jpeg", ".gif", ".png"]
      target_ext = file_exts.each do |file_ext| 
        if (@input_review.image_url.match(/#{file_ext}$/) != nil)
          break file_ext
        end
      end
      
      # お店画像フォルダへ保存するファイル名を設定
      dst_img_file_name = "#{@store.store_id}_#{@input_review.vote_id}#{target_ext}"
      @input_review.change_name = dst_img_file_name
    end
    
    # DBへ格納
    if (@input_review.save == true)
      # 下処理が残っているため、この時点では遷移しない
    else
      render(action: "new")
      return
    end
    
    # ===========================================
    #         Reviewモデルのレコードを作成
    # ===========================================
    review = Review.new
    
    review.vote_id     = @input_review.vote_id
    review.user_id     = session[:user_id]
    review.store_id    = @store.store_id
    review.menu_name   = @input_review.menu_name
    review.comment     = @input_review.comment
    review.total_score = @input_review.total_score
    review.update_date = @input_review.updated_at
    review.updated_at   = @input_review.updated_at
    
    review.save
    # ===========================================
    
    # 画像がある場合のみ画像をコピーし、モデルへ登録
    # （画像投稿では必須ではない）
    if (@input_review.image.present? == true)
      # お店画像フォルダへ画像をコピー
      dst_path = "./app/assets/images/store_img/#{dst_img_file_name}"
      FileUtils.cp("./public/#{@input_review.image_url}", dst_path)
      
      # ===========================================
      #       FoodImageモデルのレコードを作成
      # ===========================================
      food_image = FoodImage.new
      
      food_image.store_id = @store.store_id
      food_image.vote_id = @input_review.vote_id
      food_image.image_url = dst_img_file_name
      
      food_image.save
      # ===========================================
    end 
    
    redirect_to("/users/#{session[:user_id]}", notice: "口コミを投稿しました")
  end

  def show
    @store = Store.find_by(store_id: params[:store_id])
  end

  def edit
    review = Review.find_by(vote_id: params[:vote_id])
    @store = review.store
    
    @input_review = InputReview.find_by(vote_id: params[:vote_id])
  end

  def delete
  end
  
  def input_review_params
    params.require(:input_review).permit(:menu_name, :comment, :total_score, :image)
  end
end
