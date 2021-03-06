require "openssl"
require "net/http"
require "json"
require "open-uri"
require 'mini_magick'

# ==============================================================================
# 共通
# ==============================================================================
TIMEOUT_SEC = 10

# ぐるなびAPIのアクセスキーに対しての環境変数
GNAVI_API_KEY = "GNAVI_API_KEY"
# ==============================================================================

# ==============================================================================
# レストラン検索API
# ==============================================================================
REST_SEARCH_API_URI = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
HIT_PER_PAGE = 100
FREE_WORD = "がっつり,ガッツリ"

GET_IMG_PARAMS = ["shop_image1", "shop_image2"]

MAX_REST_TOTAL_HIT_NUM = 1000 # レストラン検索APIより、取得できる最大の店舗数

# ハッシュキー
REST_API_KEY_REST = "rest"
REST_API_KEY_TOTAL_HIT_NUM = "total_hit_count"
REST_API_KEY_STORE_ID = "id"
REST_API_KEY_STORE_NAME = "name"
REST_API_KEY_OPEN_TIME = "opentime"
REST_API_KEY_HOLIDAY = "holiday"
REST_API_KEY_TEL = "tel"
REST_API_KEY_ADDRESS = "address"
REST_API_KEY_ACCESS = "access"
REST_API_KEY_TRAIN_LINE = "line"
REST_API_KEY_STATION = "station"
REST_API_KEY_STATION_EXIT = "station_exit"
REST_API_KEY_WALKING_TIME = "walk"
REST_API_KEY_LATITUDE = "latitude"
REST_API_KEY_LONGITUDE = "longitude"
REST_API_KEY_CODE = "code"
REST_API_KEY_BUSINESS_LARGE_CATEGORY ="category_name_l"
REST_API_KEY_GNAVI_STORE_URL = "url"
REST_API_KEY_IMG_URL = "image_url"
# ==============================================================================

# ==============================================================================
# 応援口コミAPI
# ==============================================================================
PHOTO_API_URI = "https://api.gnavi.co.jp/PhotoSearchAPI/v3/"
PHOTO_API_MAX_EACH_RESTS = 10 # 一度のAPI実行でデータを取得できる店舗数
PHOTO_API_HIT_MAX = 50 # 1回のリクエストでヒットできる件数
PHOTO_API_GENRE_ID = 1 # 取得するジャンルID（料理・ドリンクを設定）

# ハッシュキー
PHOTO_API_KEY_RESPONSE = "response"
PHOTO_API_KEY_TOTAL_HIT = "total_hit_count"
PHOTO_API_KEY_HIT_PER_PAGE = "hit_per_page"
PHOTO_API_KEY_PHOTO = "photo"
PHOTO_API_KEY_VOTE_ID = "vote_id"
PHOTO_API_KEY_STORE_ID = "shop_id"
PHOTO_API_KEY_MENU_NAME = "menu_name"
PHOTO_API_KEY_COMMENT = "comment"
PHOTO_API_KEY_TOTAL_SCORE = "total_score"
PHOTO_API_KEY_UPDATE_DATE = "update_date"
PHOTO_API_KEY_IMAGE_URL = "image_url"
PHOTO_API_KEY_IMAGE_250_SIZE = "url_250"
# ==============================================================================

# 設定したURIのAPIデータを読み込み後、ハッシュ情報を取得
def get_hash_data(uri, https)
  # APIデータの読み込み
  res = nil
  https.start do
    res = https.get(uri.request_uri)
  end
  
  # 読み込んだデータをハッシュ化
  hash_val = JSON.parse(res.body)
  
  return hash_val	
end

# URI、httpsオブジェクトを取得
def get_https_info(set_api_uri)
  uri = URI.parse(set_api_uri)
  
  https = Net::HTTP.new(uri.host, uri.port)

  https.open_timeout = TIMEOUT_SEC
  https.read_timeout = TIMEOUT_SEC

  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  https.verify_depth = 5
  
  return uri, https
end

module Rest_Search_API
  # レストラン検索APIにより、店舗情報、画像を取得
  def self.get_api_data(pref_code)
    
    # 取得した店舗IDの格納変数（返却値）
    # ※ この関数の後に実行する、応援口コミAPIのデータ取得に使用
    store_ids = Array.new(MAX_REST_TOTAL_HIT_NUM)
    store_ids_cnt = 0
    
    # URI、httpsオブジェクトを取得
    uri, https = get_https_info(REST_SEARCH_API_URI)
    
    # 各情報の初期化
    first_read = true # 初回の読み込み処理かのフラグ（総ページ数の計算に必要）
    read_page_count = 1 # 読み込み回数
    total_page = 0 # 総ページ数（if文のみの記載だと不具合を起こすため、ここで一旦定義）
    
    loop do
      # クエリを設定
      uri.query = get_query(pref_code, read_page_count)
      
      # ハッシュ情報を取得
      hash_val = get_hash_data(uri, https)
      
      # 初回の読み込み時のみ以下処理を実行し、総ページ数を計算
      if first_read == true
        # ヒット数を表示
        puts "[total_hit_stores:#{hash_val[REST_API_KEY_TOTAL_HIT_NUM]}]"
        
        total_page = (hash_val[REST_API_KEY_TOTAL_HIT_NUM].to_f / HIT_PER_PAGE).ceil
        first_read = false
      end
      
      # レストラン情報のみ抽出
      restaurants = hash_val[REST_API_KEY_REST]
      
      # レストラン情報をモデルへ登録
      save_restaurant_model(restaurants)
      
      # 画像パスをモデルへ登録
      save_food_image_model(restaurants)
      
      # 読み込んだ店舗IDを保持
      restaurants.each do |restaurant|
        store_ids[store_ids_cnt] = restaurant[REST_API_KEY_STORE_ID]
        store_ids_cnt += 1
      end
      
      # ==============================
      # 全ページを読み込んだ場合、終了
      # ==============================
      if read_page_count >= total_page
        break
      end
      
      # 次の読み込みのため、ページ数をカウント
      read_page_count += 1
    end # loop
    
    return store_ids, store_ids_cnt
  end
  
  # レストラン検索APIについてのクエリを取得
  def self.get_query(pref_code, read_page_count)
    query = URI.encode_www_form({
              keyid: ENV[GNAVI_API_KEY],    # APIキー \
              pref: pref_code,                # 都道府県コード \
              hit_per_page: HIT_PER_PAGE,     # リクエスト1回のレスポンスデータ数 \
              offset_page: read_page_count,   # 読み込むページ位置 \
              #（このパラメータのみ、設定値が更新される）\
              freeword: FREE_WORD,            # キーワード検索
              freeword_condition: 2           # 複数のフリーワードをORで検索
            })
    
    return query
  end

  # APIより取得した複数のレストラン情報をモデルへ登録
  def self.save_restaurant_model(restaurants)
    restaurants.each do |restaurant|
      store = Store.new
      
      # ========================================================================
      #                             各カラムの設定
      # ============================== begin ===================================
      store.store_id = restaurant[REST_API_KEY_STORE_ID]               # 店舗ID
      store.name = restaurant[REST_API_KEY_STORE_NAME]                 # 店舗名称
      store.opentime = restaurant[REST_API_KEY_OPEN_TIME]              # 営業時間
      store.holiday = restaurant[REST_API_KEY_HOLIDAY]                 # 休業日
      store.tel = restaurant[REST_API_KEY_TEL]                         # 電話番号
      store.address = restaurant[REST_API_KEY_ADDRESS].gsub(/ /, "\n") # 住所
      store.line = restaurant[REST_API_KEY_ACCESS][REST_API_KEY_TRAIN_LINE]            # 路線名
      store.station = restaurant[REST_API_KEY_ACCESS][REST_API_KEY_STATION]            # 駅名
      store.station_exit = restaurant[REST_API_KEY_ACCESS][REST_API_KEY_STATION_EXIT]  # 駅出口
      store.walk = restaurant[REST_API_KEY_ACCESS][REST_API_KEY_WALKING_TIME]          # 徒歩（分）
      store.latitude = restaurant[REST_API_KEY_LATITUDE]               # 緯度
      store.longitude = restaurant[REST_API_KEY_LONGITUDE]             # 経度
      # 大業態名称（店舗のジャンル）
      # ※現時点(201/09/18)では最大2つを想定
      store_genre = restaurant[REST_API_KEY_CODE][REST_API_KEY_BUSINESS_LARGE_CATEGORY]
      store.category_name_l = store_genre[0]                           # 店舗ジャンル1
      if (store_genre[1] != "")
        store.category_name_l += "、#{store_genre[1]}"                 # 店舗ジャンル2
      end
      
      store.shop_url = restaurant[REST_API_KEY_GNAVI_STORE_URL]        # PC用URL
      
      # ※各店舗の評価値は口コミを取得後に設定
      # =============================== end ====================================
      
      # レコードへ登録
      store.save
    end
  end

  # APIより取得した複数のレストラン情報に、用意されている
  # 画像をダウンロードし保存、そして保存先をモデルへ登録
  def self.save_food_image_model(restaurants)
    restaurants.each_with_index do |restaurant, rest_index|
      GET_IMG_PARAMS.each_with_index do |get_img_param, img_index|
        
        # 画像のURLを取得
        img_url = restaurant[REST_API_KEY_IMG_URL][get_img_param]
        
        # 提供される画像データが1枚のみの場合もある
        if (img_url == "")
          next
        end
        
        # 画像URLをモデルへ登録
        store = Store.find_by(store_id: restaurant[REST_API_KEY_STORE_ID])
        store.food_images.create(image_url: img_url)
      end
      
      # 画像のDL処理が長く、ユーザがフリーズしたと思い込む
      # 可能性があるため、任意の文字を表示
      if (rest_index % 5 == 0)
        print "#"
      end
    end
    puts "" # 改行を行う
  end
  
  private_class_method :get_query, :save_restaurant_model, :save_food_image_model
  
end # module Rest_Search_API

# 応援口コミAPIデータについての処理
module Photo_Search_Api
  # 応援口コミAPIによりコメント、画像を取得
  def self.get_api_data(store_ids, store_ids_num)
    set_store_ids = Array.new(PHOTO_API_MAX_EACH_RESTS)
    
    # URI、httpsオブジェクトを取得
    uri, https = get_https_info(PHOTO_API_URI)
    
    # 読み込みレストラン情報の位置を初期化
    read_pos = 0
    
    while (read_pos < store_ids_num)
      # レストラン検索APIにより、ヒットした店舗のIDを「PHOTO_API_MAX_EACH_RESTS」件ずつ取得
      # ※ レストラン検索APIの結果数が、「PHOTO_API_MAX_EACH_RESTS」件に達しない場合も考慮
      #    例： PHOTO_API_MAX_EACH_RESTS = 10, ヒット数:6  ⇒　取得件数は6件のみ
      set_cnt = 0
      while ((set_cnt < PHOTO_API_MAX_EACH_RESTS) && (read_pos < store_ids_num ))
        set_store_ids[set_cnt] = store_ids[read_pos]
        set_cnt += 1
        read_pos += 1
      end
      
      read_page_pos = 1 # 読み込むページ位置を初期化
      first_read = true # 初回の読み込み処理かのフラグ（総ページ数の計算に必要）
      
      total_page = 0 # ループ中に情報を保持したいため、ここで宣言
      loop do
        # クエリを設定
        uri.query = get_query(set_store_ids, set_cnt, read_page_pos)
        
        # ハッシュデータを取得
        hash_val = get_hash_data(uri, https)
        hash_val = hash_val[PHOTO_API_KEY_RESPONSE]
        
        # 検索した店舗についての口コミがない場合
        if (hash_val == nil)
          break;
        end
        
        # 初回の読み込み時のみ以下処理を実行し、総ページ数を計算
      	if first_read == true
          total_page = (hash_val[PHOTO_API_KEY_TOTAL_HIT].to_f / PHOTO_API_HIT_MAX).ceil
          first_read = false
      	end
      	
      	# 応援口コミのみを抽出したハッシュ配列へ変換
      	comments = parse_comment_hash(hash_val, read_page_pos, total_page)
    	
      	# 口コミ情報をモデルへ登録
        save_review_model(comments)
        
        # 画像を保存し、画像パスをモデルへ登録
        save_food_image_model(comments)
        
        # ==============================
        # 全ページを読み込んだ場合、終了
        # ==============================
        if read_page_pos >= total_page
          break
        end
        
        # 次の読み込みのため、ページ数をカウント
        read_page_pos += 1
        
        print "#" # 処理が動いていることを示すため、文字を表示
      end # loop do 
      print "#" # 処理が動いていることを示すため、文字を表示
    end # while (read_pos < store_ids_num)
    puts "" # 処理が終わったため、改行する
  end
  
  # クエリを取得
  def self.get_query(store_ids, store_num, read_page_pos)
    # クエリの設定
    query = URI.encode_www_form({                                              \
              keyid: ENV[GNAVI_API_KEY],                    # APIキー                  \ 
              shop_id: store_ids[0...store_num].join(','),  # 店舗ID                   \
              hit_per_page: PHOTO_API_HIT_MAX,              # 最大ヒット件数           \
              offset_page: read_page_pos,                   # 読み込みページ位置       \
              photo_genre_id: PHOTO_API_GENRE_ID            # 取得する写真ジャンルID   \
            })
    
    return query
  end
  
  # 応援口コミのみを抽出したハッシュ配列へ変換
  def self.parse_comment_hash(hash_val, read_page_pos, total_page)
    # ==========================================================================
    #             ハッシュデータ内にあるコメント数を求める
    # ================================ begin ===================================
    comments_num = 0
    if (hash_val[PHOTO_API_KEY_TOTAL_HIT] <= hash_val[PHOTO_API_KEY_HIT_PER_PAGE])
      # パターン1
      # 例  ヒット件数：hash_val[PHOTO_API_KEY_TOTAL_HIT] = 10
      #     表示件数：hash_val[PHOTO_API_KEY_HIT_PER_PAGE] = 15
      #     ------------------------------------------------------
      #     コメント数 = hash_val[PHOTO_API_KEY_TOTAL_HIT] = 10
      comments_num = hash_val[PHOTO_API_KEY_TOTAL_HIT]
      
    elsif ((hash_val[PHOTO_API_KEY_TOTAL_HIT] > hash_val[PHOTO_API_KEY_HIT_PER_PAGE]) \
           && (total_page > read_page_pos))
      # パターン2
      # 例  ヒット件数：hash_val[PHOTO_API_KEY_TOTAL_HIT] = 33
      #     表示件数：hash_val[PHOTO_API_KEY_HIT_PER_PAGE] = 15
      #     総ページ数：total_page = 3
      #     読み込みページ位置: read_page_pos = 2
      #     ---------------------------------------------------------
      #     コメント数 = hash_val[PHOTO_API_KEY_HIT_PER_PAGE] = 10
      comments_num = hash_val[PHOTO_API_KEY_HIT_PER_PAGE]
      
    else
      # パターン3
      # 例  ヒット件数：hash_val[PHOTO_API_KEY_TOTAL_HIT] = 33
      #     表示件数：hash_val[PHOTO_API_KEY_HIT_PER_PAGE] = 15
      #     総ページ数：total_page = 3
      #     読み込みページ位置: read_page_pos = 3
      #     前の読み込み位置：prev_page_pos = (3 - 1) = 2
      #     ---------------------------------------------------------
      #     コメント数 =  33 - (2 * 15) = 3
      prev_page_pos = read_page_pos - 1
      comments_num = hash_val[PHOTO_API_KEY_TOTAL_HIT] - \
                       (prev_page_pos * hash_val[PHOTO_API_KEY_HIT_PER_PAGE])
    end
    # ================================= end ====================================
    
    comments = Array.new(comments_num)
    
    for loop in 0...comments_num do
      comments[loop] = hash_val[loop.to_s][PHOTO_API_KEY_PHOTO]
    end
    
    return comments
  end

  # コメント情報をモデルへ登録
  def self.save_review_model(comments)
    comments.each do |comment|
      review = Review.new
      
      # ========================================================================
      #                             各カラムの設定
      # ============================== begin ===================================
      review.vote_id = comment[PHOTO_API_KEY_VOTE_ID]          # 投稿ID
      review.user_id = nil                                     # ユーザID
                                                               # (APIより取得したデータについてはnilを設定) 
      review.store_id = comment[PHOTO_API_KEY_STORE_ID]        # 店舗ID
      review.menu_name = comment[PHOTO_API_KEY_MENU_NAME]      # メニュー名
      review.comment = comment[PHOTO_API_KEY_COMMENT]          # コメント
      review.total_score = comment[PHOTO_API_KEY_TOTAL_SCORE]  # 総合評価
      review.updated_at = comment[PHOTO_API_KEY_UPDATE_DATE]  # 投稿日時
      # =============================== end ====================================
      
      # レコードへ登録
      review.save
    end
  end

  # APIより取得した複数のレストラン情報に、用意されている画像URLを
  # モデルへ登録
  def self.save_food_image_model(comments)
    comments.each_with_index do |comment, index|
      
      # 画像URLを取得
      img_url = comment[PHOTO_API_KEY_IMAGE_URL][PHOTO_API_KEY_IMAGE_250_SIZE]
      
      # 現状は見つかってないが、画像がないコメントも想定
      if (img_url == "")
        next
      end
      
      food_image = FoodImage.new
      # ==========================================================================
      #                             各カラムの設定
      # ============================== begin =====================================
      food_image.store_id = comment[PHOTO_API_KEY_STORE_ID]  # 店舗ID
      food_image.vote_id = comment[PHOTO_API_KEY_VOTE_ID]    # 投稿ID
      food_image.image_url = img_url                         # 保存先
      # =============================== end ======================================
      
      # モデルへ登録
      food_image.save
      
      if (index % 5 == 0)
        print "#" # 処理が動いていることを示すため、文字を表示
      end
    end
  end
  
  private_class_method :get_query, :save_review_model, \
                       :save_food_image_model, :parse_comment_hash
  
end # module Photo_Search_Api

# 口コミに総合評価値に基づいて、各店舗の評価値を設定
def set_store_score_based_on_reviews
  
  stores = Store.all
  
  # 各店舗の評価値を設定
  stores.each do |store|
    
    loop do
      # まだ口コミがない店舗については「-1」を設定
      if (store.reviews.count == 0)
        store.score = -1
        break;
      end
      
      # 全ての口コミの平均店を各店舗の評価値とする
      score_sum = 0.0
      store.reviews.each do |review|
        score_sum += review.total_score
      end
      store.score = score_sum / store.reviews.count
      
      break unless false
    end
    
    # モデルを更新
    store.save
    
  end
end

desc "ぐるなびのレストラン検索API、応援口コミAPIのデータを取得(引数には都道府県マスタ取得APIより取得したコードを設定)"
task :get_gnavi_api_data, ["pref_code"] => :environment do |task, args|

  # レストラン検索APIにより、店舗情報、画像を取得
  store_ids, store_ids_num = Rest_Search_API.get_api_data(args.pref_code)
  
  # レストラン検索APIで取得した店舗に対し、応援口コミAPIデータを取得
  Photo_Search_Api.get_api_data(store_ids, store_ids_num)
  
  # 口コミに総合評価値に基づいて、各店舗の評価値を設定
  set_store_score_based_on_reviews
  
end # task :get_gnavi_api_data
