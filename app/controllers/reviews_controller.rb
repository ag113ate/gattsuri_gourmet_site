class ReviewsController < ApplicationController
  before_action :require_login, except: [:show]
  
  def new
    @store = Store.find_by(store_id: params[:store_id])
    @input_review = InputReview.new
    
  end

  def create
    @store = Store.find_by(store_id: params[:store_id])
    
    @input_review = InputReview.new(input_review_params)
    @input_review.user_id = session[:user_id]
    @input_review.store_id = @store.store_id
    
    # =================================================
    #                 投稿IDの設定
    # =================================================
    vote_id = 0
    random = Random.new(88)
    
    # 既存のレコードの投稿IDと重複しない乱数値を取得
    # （仕様上、「APIから取得した投稿」と「本システムで行った各ユーザの投稿」は
    #   別のテーブルで管理するが、何かしらの仕様変更が発生しても対応できるよう、
    #   2つのテーブル全体で投稿IDが重複しないようにする）
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
    
    # DBへ格納
    if (@input_review.save == true)
      redirect_to("/users/#{session[:user_id]}", notice: "口コミを投稿しました")
    else
      render("new")
      return
    end
  end
  
  def update
    @store = Store.find_by(store_id: params[:store_id])
    
    @input_review = InputReview.find_by(vote_id: params[:vote_id])
    
    # DBへ更新
    if (@input_review.update(input_review_params) == true)
      redirect_to("/users/#{session[:user_id]}", notice: "口コミを更新しました")
    else
      render("edit")
      return;
    end
  end

  def show
    @store = Store.find_by(store_id: params[:store_id])
  end

  def edit
    review = InputReview.find_by(vote_id: params[:vote_id])
    @store = review.store
    
    @input_review = InputReview.find_by(vote_id: params[:vote_id])
  end

  def delete
    @input_review = Review.find_by(vote_id: params[:vote_id])
    @input_review.destroy
    
    user = User.find_by(user_id: session[:user_id])
    
    @input_review_count = user.input_reviews.count
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def input_review_params
    params.require(:input_review).permit(:menu_name, :comment, :total_score, :image)
  end
end
