require "openssl"
require "net/http"
require "json"

TIMEOUT_SEC = 10
HIT_PER_PAGE = 100

# クエリの生成
def create_query_params(read_page_count)
  params = URI.encode_www_form({
  keyid: ENV["GNAVI_API_KEY"],  # APIキー \
  hit_per_page: HIT_PER_PAGE,   # リクエスト1回のレスポンスデータ数\
  offset_page: read_page_count, # 読み込むページ位置 \
                                #（このパラメータのみ、設定値が更新される）\
  freeword: "がっつり"})        # キーワード検索
  
  return params
end
    
# APIより取得した複数のレストラン情報をモデルへ登録
def save_restaurants_info(restaurants)
  
  restaurants.each do |restaurant|
    store = Store.new
    
    # 各カラムの設定
	  store.id = restaurant["id"]                               # 店舗ID
	  store.name = restaurant["name"]                           # 店舗名称
	  store.review = 3.5                                        # レビュー評価値 ※暫定処理
	  store.opentime = restaurant["opentime"]                   # 営業時間
	  store.holiday = restaurant["holiday"]                     # 休業日
	  store.tel = restaurant["tel"]                             # 電話番号
	  store.address = restaurant["address"].gsub(/ /, "\n")     # 住所
	  store.line = restaurant["access"]["line"]                 # 路線名
	  store.station = restaurant["access"]["station"]           # 駅名
	  store.station_exit = restaurant["access"]["station_exit"] # 駅出口
	  store.walk = restaurant["access"]["walk"]                 # 徒歩（分）
	  store.latitude = restaurant["latitude"]                   # 緯度
	  store.longitude = restaurant["longitude"]                 # 経度
	  # 大業態名称（店舗のジャンル）
	  # ※現時点(201/09/18)では最大2つを想定
	  store_genre = restaurant["code"]["category_name_l"]       # 店舗ジャンル1
	  store.category_name_l = store_genre[0] 
	  if (store_genre[1] != "")
	    store.category_name_l += "、#{store_genre[1]}"          # 店舗ジャンル2
	  end
	  
	  store.shop_url = restaurant["url"]                        # PC用URL
	  
	  # レコードへ登録
	  store.save
  end
end

desc "ぐるなびAPIより、店舗情報を取得"
task :read_store_info => :environment do
  uri = URI.parse("https://api.gnavi.co.jp/RestSearchAPI/v3/")
  https = Net::HTTP.new(uri.host, uri.port)

  https.open_timeout = TIMEOUT_SEC
  https.read_timeout = TIMEOUT_SEC

  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  https.verify_depth = 5
  
  # 各情報の初期化
  first_read = true # 初回の読み込み処理かのフラグ（総ページ数の計算に必要）
  read_page_count = 1 # 読み込み回数
  total_page = 0 # 総ページ数（if文のみの記載だと不具合を起こすため、ここで一旦定義）
  
  loop do
  	# クエリを設定
  	uri.query = create_query_params(read_page_count)
  	
  	# APIデータの読み込み
  	res = nil
  	https.start do
    	res = https.get(uri.request_uri)
  	end
  	
  	# 読み込みデータをハッシュ化
  	hash_val = JSON.parse(res.body)
  	
    # 初回の読み込み時のみ以下処理を実行し、総ページ数を計算
  	if first_read == true
  		total_page = (hash_val["total_hit_count"].to_f / HIT_PER_PAGE).ceil
  		first_read = false
  	end
  	
  	# レストラン情報のみ抽出
  	restaurants = hash_val["rest"]
  	
  	# レストラン情報をモデルへ登録
  	save_restaurants_info(restaurants)
  	  	
  	# 全ページを読み込んだ場合、終了
  	if read_page_count >= total_page
  		break
  	end
  	
  	# 一時処理
  	break
  	
  	# 次の読み込みのため、ページ数をカウント
  	read_page_count += 1
  end # loop
  
end # task :get_store_info

desc "モデル読み込み動作確認"
task :test_model => :environment do
  
  stores = Store.all
  
  stores.each do |store|
    puts store.name
  end
end