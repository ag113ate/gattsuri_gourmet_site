class ReviewsController < ApplicationController
  before_action :require_login, except: [:show]
  
  def new
    @store = Store.find_by(store_id: params[:store_id])
    @input_review = InputReview.new
    
    # 遷移元がログインページ(/users/index)、あるいは
    # アカウント作成ページ(/users/new)だった場合
    #     ・末ログイン状態で「口コミを書く」をクリック
    #     ・システムにより、ログインを要求              となる
    # この場合、require_loginメソッド内で、session[:review_complete_link]に
    # 格納されるURLを設定されているため、ここでの処理は不要
    path = Rails.application.routes.recognize_path(request.referer)
    if !( ((path[:controller] == "users") && (path[:action] == "index")) ||
          ((path[:controller] == "users") && (path[:action] == "new"  ))  )
      if (request.referer != nil)
        session[:review_complete_link] = URI(request.referer).request_uri
      else
        session[:review_complete_link] = nil
      end
    end
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
    is_success_save = @input_review.save
    if (is_success_save && (session[:review_complete_link] != nil))
      redirect_to(session[:review_complete_link], notice: "口コミを投稿しました")
      session[:review_complete_link] = nil
      
    elsif (is_success_save && (session[:review_complete_link] == nil))
      redirect_to("/users/#{session[:user_id]}", notice: "口コミを投稿しました")
      
    else
      render("new")
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
    @input_review = InputReview.find_by(vote_id: params[:vote_id])
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
